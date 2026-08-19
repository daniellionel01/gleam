// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Gleam contributors

//! Red team probing surface for the compiler, driven EXTERNALLY.
//!
//! This crate lives entirely OUTSIDE compiler-core. It composes only the
//! public API of `gleam_core` (parse, analyse, erlang, javascript, type_,
//! build, codegen, uid, warning) plus the separate `src-span` crate for
//! `LineNumbers`. Nothing in compiler-core is modified.
//!
//! The central contract:
//!
//!   THE COMPILER MUST NEVER PANIC, on ANY input — valid or invalid.
//!
//! Invalid inputs must produce a `ParseError` or an analysis rejection.
//! Valid inputs must produce target code for both supported targets.
//! Anything else is a bug, and `probe_guarded` turns it into evidence.

use std::collections::{HashMap, HashSet};
use std::fmt;

use camino::{Utf8Path, Utf8PathBuf};
use ecow::EcoString;
use gleam_core::{
    analyse::{ModuleAnalyzerConstructor, TargetSupport},
    ast::{TypedModule, UntypedModule},
    build::{Origin, Outcome, Target, package_compiler::StdlibPackage},
    codegen::TypeScriptDeclarations,
    config::PackageConfig,
    erlang, javascript, parse,
    type_::{self, PRELUDE_MODULE_NAME},
    uid::UniqueIdGenerator,
    warning::{TypeWarningEmitter, WarningEmitter},
};
use src_span::LineNumbers;

/// Inputs larger than this are not probed. Keeps fuzz iterations fast and
/// avoids conflating resource exhaustion with real bugs.
pub const MAX_INPUT_BYTES: usize = 16 * 1024;

/// What happened when we pushed an input through the compiler pipeline.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ProbeOutcome {
    /// Input exceeded `MAX_INPUT_BYTES`.
    InputTooLarge,
    /// Input was not valid UTF-8.
    NotUtf8,
    /// Rejected by the parser. Normal outcome for invalid programs.
    ParseError,
    /// Rejected by the type checker / analyser for the given target.
    /// Normal outcome for invalid programs.
    AnalysisRejected { target: &'static str },
    /// Parsed successfully (parser-only probe).
    ParsedOk,
    /// Full pipeline succeeded: analysed and code generated for both
    /// the JavaScript and Erlang targets, plus TypeScript declarations.
    Compiled {
        javascript_bytes: usize,
        typescript_bytes: usize,
        erlang_bytes: usize,
    },
}

impl fmt::Display for ProbeOutcome {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            ProbeOutcome::InputTooLarge => write!(f, "input too large"),
            ProbeOutcome::NotUtf8 => write!(f, "not utf-8"),
            ProbeOutcome::ParseError => write!(f, "parse error"),
            ProbeOutcome::AnalysisRejected { target } => {
                write!(f, "analysis rejected ({target})")
            }
            ProbeOutcome::ParsedOk => write!(f, "parsed ok"),
            ProbeOutcome::Compiled {
                javascript_bytes,
                typescript_bytes,
                erlang_bytes,
            } => write!(
                f,
                "compiled (js: {javascript_bytes}B, ts: {typescript_bytes}B, erl: {erlang_bytes}B)"
            ),
        }
    }
}

/// Parser-only probe over raw bytes. Never panics by contract.
pub fn probe_parse_bytes(data: &[u8]) -> ProbeOutcome {
    if data.len() > MAX_INPUT_BYTES {
        return ProbeOutcome::InputTooLarge;
    }
    let src = match std::str::from_utf8(data) {
        Ok(src) => src,
        Err(_) => return ProbeOutcome::NotUtf8,
    };
    match parse_ok(src) {
        Some(_) => ProbeOutcome::ParsedOk,
        None => ProbeOutcome::ParseError,
    }
}

/// Full-pipeline probe over raw bytes.
pub fn probe_bytes(data: &[u8]) -> ProbeOutcome {
    if data.len() > MAX_INPUT_BYTES {
        return ProbeOutcome::InputTooLarge;
    }
    match std::str::from_utf8(data) {
        Ok(src) => probe_source(src),
        Err(_) => ProbeOutcome::NotUtf8,
    }
}

/// Full-pipeline probe over a string.
pub fn probe_source(src: &str) -> ProbeOutcome {
    if parse_ok(src).is_none() {
        return ProbeOutcome::ParseError;
    }

    let Some(javascript_output) = compile_javascript(src) else {
        return ProbeOutcome::AnalysisRejected {
            target: "javascript",
        };
    };
    let Some(typescript_output) = compile_typescript_declarations(src) else {
        return ProbeOutcome::AnalysisRejected {
            target: "typescript",
        };
    };
    let Some(erlang_output) = compile_erlang(src) else {
        return ProbeOutcome::AnalysisRejected { target: "erlang" };
    };

    ProbeOutcome::Compiled {
        javascript_bytes: javascript_output.len(),
        typescript_bytes: typescript_output.len(),
        erlang_bytes: erlang_output.len(),
    }
}

/// Catch any compiler panic and return it as a string payload.
pub fn probe_guarded(data: &[u8]) -> Result<ProbeOutcome, String> {
    std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| probe_bytes(data)))
        .map_err(|payload| panic_payload_to_string(&payload))
}

fn panic_payload_to_string(payload: &Box<dyn std::any::Any + Send>) -> String {
    if let Some(message) = payload.downcast_ref::<&str>() {
        (*message).to_string()
    } else if let Some(message) = payload.downcast_ref::<String>() {
        message.clone()
    } else {
        "unknown panic payload".to_string()
    }
}

/// Panic signatures of CONFIRMED compiler bugs. Fuzz harnesses and
/// generated-program validators treat these as expected, so they skip known
/// bugs while still reporting any NEW panic signature.
pub fn is_known_compiler_bug(panic: &str) -> bool {
    panic.contains("Token could not be converted to binop")
        || panic.contains("variable not in scope")
}

/// Compile a single-module program to JavaScript.
pub fn compile_javascript(src: &str) -> Option<String> {
    let (typed, line_numbers) = analyse(src, Target::JavaScript)?;
    let src_eco = EcoString::from(src);
    let (output, _) = javascript::module(javascript::ModuleConfig {
        module: &typed,
        line_numbers: &line_numbers,
        src: &src_eco,
        typescript: TypeScriptDeclarations::None,
        source_map: false,
        stdlib_package: StdlibPackage::Present,
        path: Utf8Path::new("src/redteam_probe.gleam"),
        project_root: Utf8Path::new("redteam/root"),
    });
    Some(output)
}

/// Compile a single-module program to TypeScript declarations.
pub fn compile_typescript_declarations(src: &str) -> Option<String> {
    let (typed, _) = analyse(src, Target::JavaScript)?;
    Some(javascript::ts_declaration(&typed))
}

/// Compile a single-module program to Erlang.
pub fn compile_erlang(src: &str) -> Option<String> {
    let (typed, line_numbers) = analyse(src, Target::Erlang)?;
    Some(erlang::module(
        &typed,
        line_numbers,
        Utf8Path::new("redteam/root"),
    ))
}

fn parse_ok(src: &str) -> Option<UntypedModule> {
    parse::parse_module(
        Utf8PathBuf::from("redteam/probe.gleam"),
        src,
        &WarningEmitter::null(),
    )
    .ok()
    .map(|parsed| parsed.module)
}

/// Analyse a single module with only the prelude available.
fn analyse(src: &str, target: Target) -> Option<(TypedModule, LineNumbers)> {
    let ids = UniqueIdGenerator::new();
    let mut modules = im::HashMap::new();
    let _ = modules.insert(PRELUDE_MODULE_NAME.into(), type_::build_prelude(&ids));

    let mut ast = parse_ok(src)?;
    ast.name = "redteam/probe".into();

    let mut config = PackageConfig::default();
    config.name = "redteam".into();
    let direct_dependencies: HashMap<EcoString, ()> = HashMap::new();
    let dev_dependencies: HashSet<EcoString> = HashSet::new();

    let outcome = ModuleAnalyzerConstructor::<()> {
        target,
        ids: &ids,
        origin: Origin::Src,
        importable_modules: &modules,
        warnings: &TypeWarningEmitter::null(),
        direct_dependencies: &direct_dependencies,
        dev_dependencies: &dev_dependencies,
        target_support: TargetSupport::NotEnforced,
        package_config: &config,
    }
    .infer_module(
        ast,
        LineNumbers::new(src),
        "src/redteam_probe.gleam".into(),
    );

    match outcome {
        Outcome::Ok(typed) => Some((typed, LineNumbers::new(src))),
        Outcome::PartialFailure(..) | Outcome::TotalFailure(_) => None,
    }
}
