// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Gleam contributors

//! Fuzzing binary: generate well-typed Gleam programs and run them on both
//! backends, reporting divergences.
//!
//! Usage:
//!   fuzz run <seed>                  generate + compare one program
//!   fuzz batch <start> <count>       run seeds start..start+count
//!
//! Exit codes: 0 = match (or batch completed), 1 = mismatch, 2 = usage error.
//!
//! `cd fuzzing-harness && cargo build --release --bin fuzz`

use std::env;
use std::fs;
use std::process::Command;

use fuzzing_core::generator::Module;
use fuzzing_core::value::{self, Value};
use gleam_core::build::Target;

fn main() {
    let args: Vec<String> = env::args().collect();
    match args.get(1).map(String::as_str) {
        Some("run") => cmd_run(&args[2..]),
        Some("batch") => cmd_batch(&args[2..]),
        _ => {
            eprintln!("usage:\n  fuzz run <seed>\n  fuzz batch <start> <count>");
            std::process::exit(2);
        }
    }
}

fn cmd_run(args: &[String]) {
    let seed: u64 = args
        .first()
        .and_then(|s| s.parse().ok())
        .unwrap_or_else(|| {
            eprintln!("usage: fuzz run <seed>");
            std::process::exit(2);
        });

    let module = Module::from_seed(seed);
    let outcome = run_and_compare(&module);

    println!("=== fuzz ===");
    println!("seed:        {seed}");
    println!("erlang exit: {}", outcome.erl_status);
    println!("nodejs exit: {}", outcome.js_status);
    println!("");
    println!("erlang: {:?}", outcome.erl_values);
    println!("nodejs: {:?}", outcome.js_values);
    println!(
        "verdict: {}",
        if outcome.matched { "MATCH" } else { "MISMATCH" }
    );

    std::process::exit(if outcome.matched { 0 } else { 1 });
}

fn cmd_batch(args: &[String]) {
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

    eprintln!("[fuzz] seeds {start}..{}", start + count - 1);
    let mut found = 0u64;
    let mut ran = 0u64;

    for seed in start..start + count {
        let module = Module::from_seed(seed);
        let src = module.to_source();

        // Save generated program to corpus
        let corpus_path = std::path::Path::new(corpus_dir).join(format!("seed_{seed}.gleam"));
        fs::write(&corpus_path, &src).expect("write corpus");

        let outcome = run_and_compare(&module);

        if !outcome.matched {
            // Copy to artifacts (the finding)
            let artifact_path =
                std::path::Path::new(artifacts_dir).join(format!("seed_{seed}.gleam"));
            fs::write(&artifact_path, &src).expect("write artifact");
            eprintln!(
                "[fuzz] DIVERGENCE seed {seed} -> {}",
                artifact_path.display()
            );
            eprintln!("  erlang:   {:?}", outcome.erl_values);
            eprintln!("  nodejs:   {:?}", outcome.js_values);
            found += 1;
        }

        ran += 1;
        if ran % 10 == 0 {
            eprintln!("[fuzz] {ran}/{count} run, {found} divergences");
        }
    }

    eprintln!(
        "[fuzz] done: {ran} programs in {corpus_dir}, {found} divergence(s) in {artifacts_dir}"
    );
}

struct Outcome {
    erl_values: Vec<Value>,
    js_values: Vec<Value>,
    erl_status: i32,
    js_status: i32,
    matched: bool,
}

fn run_and_compare(module: &Module) -> Outcome {
    let src = module.to_source();
    let work = tempfile::tempdir().expect("create temp dir");
    let project_dir = work.path();

    // Set up temp project
    let src_dir = project_dir.join("src");
    fs::create_dir_all(&src_dir).expect("create src dir");
    fs::write(src_dir.join("main.gleam"), &src).expect("write main.gleam");
    fs::write(project_dir.join("gleam.toml"), "name = \"fuzzing_case\"\n")
        .expect("write gleam.toml");

    let run = |target: &str, extra: &[&str]| -> (String, i32) {
        let mut cmd = Command::new("gleam");
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

    let erl_values = value::parse_output(&erl_raw, Target::Erlang);
    let js_values = value::parse_output(&js_raw, Target::JavaScript);

    let matched = erl_status == 0 && js_status == 0 && value::outputs_match_cross_target(&erl_values, &js_values);

    Outcome {
        erl_values,
        js_values,
        erl_status,
        js_status,
        matched,
    }
}
