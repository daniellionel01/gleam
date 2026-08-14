// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Gleam contributors

//! Red team probing interface for the compiler.
//!
//! This module provides a small, stable surface that the fuzzing and
//! differential-testing tooling in `redteam/` drives. The central contract:
//!
//!   THE COMPILER MUST NEVER PANIC, on ANY input — valid or invalid.
//!
//! Invalid inputs must produce a `ParseError` or an analysis rejection.
//! Valid inputs must produce target code for both supported targets.
//! Anything else is a bug, and `probe_guarded` turns it into evidence.
//!
//! See `redteam/README.md` for the full red team program.

use std::collections::{HashMap, HashSet};
use std::fmt;

use camino::{Utf8Path, Utf8PathBuf};
use ecow::EcoString;
use src_span::LineNumbers;

use crate::{
    analyse::{ModuleAnalyzerConstructor, TargetSupport},
    ast::{TypedModule, UntypedModule},
    build::{Origin, Outcome, Target, package_compiler::StdlibPackage},
    codegen::TypeScriptDeclarations,
    config::PackageConfig,
    erlang, inline, javascript, parse,
    type_::{self, prelude::PRELUDE_MODULE_NAME},
    uid::UniqueIdGenerator,
    warning::{TypeWarningEmitter, WarningEmitter},
};

/// Inputs larger than this are not probed. Keeps fuzz iterations fast and
/// avoids conflating resource exhaustion with real bugs. Stack-overflow
/// style inputs (deeply nested structures) are a separate campaign that
/// will use dedicated depth-bounded generation.
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

/// Parser-only probe over raw bytes. Never panics by contract; a panic here
/// is a bug in the lexer or parser.
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

/// Full-pipeline probe over raw bytes: parse, analyse, and generate code for
/// both targets plus TypeScript declarations. Never panics by contract.
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

/// Catch any compiler panic and return it as a string payload, so corpus
/// replay and triage tooling can report it as evidence instead of dying.
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

/// Panic signatures of CONFIRMED compiler bugs tracked in
/// `redteam/findings.md`. Fuzz harnesses and generated-program validators
/// must treat these as expected: skipping them avoids rediscovering known
/// bugs forever, while any NEW panic signature still gets reported.
/// Every entry MUST reference a findings.md finding number.
pub fn is_known_compiler_bug(panic: &str) -> bool {
    // F-5: parse.rs `constant_binop_reduction` — `|>` (and other non-binop
    // tokens) inside constant definitions panic the parser.
    panic.contains("Token could not be converted to binop")
    // F-6: erlang.rs `local_var_name` — immediately-applied anonymous fn
    // param shadowed by a `let` in one case clause body, used in later
    // clauses; also nested anon fns capturing outer anon params.
    // F-7: erlang.rs `local_var_name` — guarded alternative list pattern
    // following an exact-length list pattern clause.
    || panic.contains("variable not in scope")
}

/// Compile a single-module program to JavaScript.
///
/// Returns `None` if the module is rejected by the analyser. May only panic
/// on compiler bugs — that's what the red team tooling listens for.
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

/// Analyse a single module with only the prelude available, mirroring the
/// setup used by the compiler's own codegen test suites.
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
        // Only fully successful analysis is allowed to reach code generation,
        // mirroring the real build pipeline: `PartialFailure` carries analysis
        // errors, and codegen on such a module is unreachable in practice.
        Outcome::Ok(typed) => {
            let typed = inline::module(typed, &modules);
            Some((typed, LineNumbers::new(src)))
        }
        Outcome::PartialFailure(..) | Outcome::TotalFailure(_) => None,
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::path::PathBuf;

    /// Manually replay a single input (e.g. a fuzz artifact) against the
    /// full pipeline. Not part of the suite:
    ///   REDTEAM_REPLAY=path/to/input cargo test -p gleam-core redteam -- --ignored --nocapture
    #[test]
    #[ignore = "manual replay helper, driven by REDTEAM_REPLAY"]
    fn replay_file_from_env() {
        let path = std::env::var("REDTEAM_REPLAY").expect("set REDTEAM_REPLAY to a file path");
        let data = std::fs::read(&path).expect("read replay file");
        println!("--- input:\n{}", String::from_utf8_lossy(&data));
        match probe_guarded(&data) {
            Ok(outcome) => println!("--- outcome: {outcome}"),
            Err(panic) => panic!("--- compiler PANICKED: {panic}"),
        }
    }

    /// Every file in `redteam/corpus/` is pushed through the full pipeline.
    /// Parse errors and analysis rejections are fine. A panic is a bug and
    /// fails the build of `gleam-core` itself.
    #[test]
    fn corpus_is_panic_free() {
        let dir = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../redteam/corpus");
        let entries = std::fs::read_dir(&dir)
            .unwrap_or_else(|error| panic!("cannot read {}: {error}", dir.display()));

        let mut probed = 0;
        let mut failures = Vec::new();
        for entry in entries.flatten() {
            let path = entry.path();
            if path.extension().and_then(|e| e.to_str()) != Some("gleam") {
                continue;
            }
            probed += 1;
            let data = std::fs::read(&path).expect("read corpus file");
            if let Err(panic) = probe_guarded(&data) {
                failures.push(format!("{}\n  panic: {}", path.display(), panic));
            }
        }

        assert!(probed > 0, "no corpus files found in {}", dir.display());
        assert!(
            failures.is_empty(),
            "compiler panicked on {} of {} corpus inputs:\n{}",
            failures.len(),
            probed,
            failures.join("\n")
        );
    }
}
