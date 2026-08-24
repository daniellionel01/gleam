// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Gleam contributors

//! Fuzzing binary: generate well-typed Gleam programs and run them on both
//! backends, reporting divergences.
//!
//! Usage:
//!   fuzz run <seed>                  generate + compare one program
//!   fuzz batch <start> <count>       run seeds start..start+count
//!   fuzz --gleam-bin <path> ...      use a different Gleam binary
//!
//! By default `fuzz` looks for a Gleam build at `<repo>/target/release/gleam`
//! (the local nightly from this repository). If that doesn't exist, it
//! falls back to `gleam` from $PATH. Override either with `--gleam-bin <path>`
//! or the `FUZZ_GLEAM_BIN` environment variable. The path actually used is
//! printed at startup.
//!
//! Exit codes: 0 = match (or batch completed), 1 = mismatch, 2 = usage error.
//!
//! `cd fuzzing-harness && cargo build --release --bin fuzz`

use std::env;
use std::fs;
use std::path::PathBuf;
use std::process::Command;

use fuzzing_core::generator::Module;
use fuzzing_core::value;
use gleam_core::build::Target;

fn main() {
    let args: Vec<String> = env::args().collect();
    let (gleam_bin, rest) = resolve_gleam_bin(&args);
    match rest.get(0).map(String::as_str) {
        Some("run") => cmd_run(&rest[1..], &gleam_bin),
        Some("batch") => cmd_batch(&rest[1..], &gleam_bin),
        _ => {
            eprintln!(
                "usage:\n  fuzz run <seed>\n  fuzz batch <start> <count>\n  fuzz --gleam-bin <path> ..."
            );
            std::process::exit(2);
        }
    }
}

fn resolve_gleam_bin(args: &[String]) -> (PathBuf, Vec<String>) {
    let mut override_path: Option<PathBuf> = None;
    let mut rest_start = args.len();
    for (i, a) in args.iter().enumerate() {
        if a == "--gleam-bin" {
            if let Some(path) = args.get(i + 1) {
                override_path = Some(PathBuf::from(path));
                rest_start = i + 2;
                break;
            }
        }
        if let Some(value) = a.strip_prefix("--gleam-bin=") {
            override_path = Some(PathBuf::from(value));
            rest_start = i + 1;
            break;
        }
    }
    if override_path.is_none() {
        if let Ok(value) = env::var("FUZZ_GLEAM_BIN") {
            override_path = Some(PathBuf::from(value));
        }
    }
    let rest: Vec<String> = if rest_start >= args.len() {
        args[1..].to_vec()
    } else if override_path.is_some() {
        args[rest_start..].to_vec()
    } else {
        args[1..].to_vec()
    };
    let bin = override_path.unwrap_or_else(default_gleam_bin);
    (bin, rest)
}

fn default_gleam_bin() -> PathBuf {
    // Walk up from CWD looking for a sibling target/release/gleam.
    let mut dir = env::current_dir().unwrap_or_else(|_| PathBuf::from("."));
    loop {
        let candidate = dir.join("target").join("release").join("gleam");
        if candidate.is_file() {
            return candidate;
        }
        if !dir.pop() {
            break;
        }
    }
    PathBuf::from("gleam")
}

fn cmd_run(args: &[String], gleam_bin: &std::path::Path) {
    let seed: u64 = args
        .first()
        .and_then(|s| s.parse().ok())
        .unwrap_or_else(|| {
            eprintln!("usage: fuzz run <seed>");
            std::process::exit(2);
        });

    let module = Module::from_seed(seed);
    let outcome = run_and_compare(&module, gleam_bin);

    println!("=== fuzz ===");
    println!("seed:        {seed}");
    println!("gleam:       {}", gleam_bin.display());
    println!("erlang exit: {}", outcome.erl_status);
    println!("nodejs exit: {}", outcome.js_status);
    println!("match:       {}", outcome.matched);
    if let Some(note) = &outcome.skip_note {
        println!("note:        {note} (skipped in batch)");
    }

    std::process::exit(if outcome.matched || outcome.skip_note.is_some() {
        0
    } else {
        1
    });
}

fn cmd_batch(args: &[String], gleam_bin: &std::path::Path) {
    let start: u64 = args
        .first()
        .and_then(|s| s.parse().ok())
        .unwrap_or_else(|| {
            eprintln!("usage: fuzz batch <start> <count>");
            std::process::exit(2);
        });
    let count: u64 = args.get(1).and_then(|s| s.parse().ok()).unwrap_or_else(|| {
        eprintln!("usage: fuzz batch <start> <count>");
        std::process::exit(2);
    });

    let corpus_dir = "corpus/fuzz";
    let artifacts_dir = "artifacts/fuzz";
    fs::create_dir_all(corpus_dir).expect("create corpus dir");
    fs::create_dir_all(artifacts_dir).expect("create artifacts dir");

    eprintln!("[fuzz] gleam: {}", gleam_bin.display());
    eprintln!("[fuzz] seeds {start}..{}", start + count - 1);
    let mut mismatches = 0u64;
    let mut skipped = 0u64;
    let mut ran = 0u64;

    for seed in start..start + count {
        let module = Module::from_seed(seed);
        let src = module.to_source();

        let corpus_path = std::path::Path::new(corpus_dir).join(format!("seed_{seed}.gleam"));
        fs::write(&corpus_path, &src).expect("write corpus");

        let outcome = run_and_compare(&module, gleam_bin);

        if !outcome.matched {
            if outcome.skip_note.is_some() {
                skipped += 1;
                continue;
            }
            let artifact_path =
                std::path::Path::new(artifacts_dir).join(format!("seed_{seed}.gleam"));
            fs::write(&artifact_path, &src).expect("write artifact");
            eprintln!(
                "[fuzz] DIVERGENCE seed {seed} -> erlang:{} nodejs:{}",
                outcome.erl_status, outcome.js_status,
            );
            mismatches += 1;
        }

        ran += 1;
        if ran % 10 == 0 {
            eprintln!("[fuzz] {ran}/{count} run, {mismatches} mismatches, {skipped} skipped");
        }
    }

    eprintln!("[fuzz] done: {ran} programs, {mismatches} mismatch(es), {skipped} skipped");
}

struct Outcome {
    erl_status: i32,
    js_status: i32,
    matched: bool,
    skip_note: Option<String>,
}

fn run_and_compare(module: &Module, gleam_bin: &std::path::Path) -> Outcome {
    let src = module.to_source();
    let work = tempfile::tempdir().expect("create temp dir");
    let project_dir = work.path();

    let src_dir = project_dir.join("src");
    fs::create_dir_all(&src_dir).expect("create src dir");
    fs::write(src_dir.join("main.gleam"), &src).expect("write main.gleam");
    fs::write(project_dir.join("gleam.toml"), "name = \"fuzzing_case\"\n")
        .expect("write gleam.toml");

    let run = |target: &str, extra: &[&str]| -> (String, i32) {
        let mut cmd = Command::new(gleam_bin);
        cmd.arg("run")
            .arg("--target")
            .arg(target)
            .arg("--module")
            .arg("main")
            .args(extra)
            .current_dir(project_dir);

        let out = cmd.output().expect("run gleam");
        let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
        let stderr = String::from_utf8_lossy(&out.stderr).into_owned();
        (format!("{stdout}{stderr}"), out.status.code().unwrap_or(-1))
    };

    let (erl_raw, erl_status) = run("erlang", &[]);
    let (js_raw, js_status) = run("javascript", &["--runtime", "nodejs"]);

    let erl_ok = erl_status == 0;
    let js_ok = js_status == 0;

    let matched = if erl_ok && js_ok {
        let erl_values = value::parse_output(&erl_raw, Target::Erlang);
        let js_values = value::parse_output(&js_raw, Target::JavaScript);
        value::outputs_match_cross_target(&erl_values, &js_values)
    } else if !erl_ok && !js_ok {
        value::strip_build_noise(&erl_raw) == value::strip_build_noise(&js_raw)
    } else {
        false
    };

    let skip_note = known_skips(&erl_raw, &js_raw, erl_status, js_status);

    Outcome {
        erl_status,
        js_status,
        matched,
        skip_note,
    }
}

// Add a new entry here to filter a known issue. Each rule returns Some(note)
// when the result should be skipped with that note, or None to defer to
// the next rule / treat as a real result.
fn known_skips(erl_raw: &str, js_raw: &str, erl_status: i32, js_status: i32) -> Option<String> {
    let erl_ok = erl_status == 0;
    let js_ok = js_status == 0;

    // https://github.com/erlang/otp/issues/11494
    if !erl_ok && js_ok && is_erlang_otp_issue_11494(erl_raw) {
        return Some("otp issue #11494".into());
    }

    // https://github.com/gleam-lang/gleam/issues/6182
    if erl_ok && !js_ok && is_gleam_issue_6182(js_raw) {
        return Some("gleam issue #6182".into());
    }

    // https://github.com/gleam-lang/gleam/issues/6212
    if erl_ok && !js_ok && is_gleam_issue_6212(js_raw) {
        return Some("gleam issue #6212".into());
    }

    None
}

// https://github.com/erlang/otp/issues/11494
fn is_erlang_otp_issue_11494(raw: &str) -> bool {
    raw.contains("Internal consistency check failed")
        && raw.contains("call_only")
        && raw.contains("bad_arg_type")
        && raw.contains("{x,")
        && raw.contains("t_union")
        && raw.contains("t_bitstring")
}

// https://github.com/gleam-lang/gleam/issues/6182
fn is_gleam_issue_6182(raw: &str) -> bool {
    raw.contains("SyntaxError: Unexpected token '&&'")
        || raw.contains("SyntaxError: Unexpected token ')'")
}

// https://github.com/gleam-lang/gleam/issues/6212
fn is_gleam_issue_6212(raw: &str) -> bool {
    raw.contains("TypeError:") && raw.contains("is not a function")
}
