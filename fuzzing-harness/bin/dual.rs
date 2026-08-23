// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Gleam contributors

//! Usage:
//!   dual path/to/case.gleam
//!
//! Exit codes: 0 = match, 1 = mismatch, 2 = usage error.
//!
//! `cd fuzzing-harness && cargo build --release --bin dual`

use std::env;
use std::fs;
use std::process::Command;

fn main() {
    let args: Vec<String> = env::args().collect();
    let input = args.get(1).expect("usage: dual <case.gleam>");

    let work = tempfile::tempdir().expect("create temp dir");
    let src = work.path().join("src");
    fs::create_dir_all(&src).expect("create src dir");
    fs::copy(input, src.join("main.gleam")).expect("copy input");
    fs::write(work.path().join("gleam.toml"), "name = \"fuzzing_case\"\n")
        .expect("write gleam.toml");

    let run = |target: &str, extra: &[&str]| -> (String, i32) {
        let mut cmd = Command::new("gleam");
        cmd.arg("run")
            .arg("--target")
            .arg(target)
            .arg("--module")
            .arg("main")
            .args(extra)
            .current_dir(work.path());

        let out = cmd.output().expect("run gleam");
        let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
        let stderr = String::from_utf8_lossy(&out.stderr).into_owned();
        (format!("{stdout}{stderr}"), out.status.code().unwrap_or(-1))
    };

    let (erl_raw, erl_status) = run("erlang", &[]);
    let (js_raw, js_status) = run("javascript", &["--runtime", "nodejs"]);

    let erl_out = normalise(&erl_raw);
    let js_out = normalise(&js_raw);
    let matched = erl_status == 0 && js_status == 0 && erl_out == js_out;

    println!("=== fuzzing dual ===");
    println!("input:           {input}");
    println!("erlang status:   {erl_status}");
    println!("nodejs status:   {js_status}");
    println!(
        "verdict:         {}",
        if matched { "MATCH" } else { "MISMATCH" }
    );
    println!("--- erlang output (normalised) ---");
    for line in &erl_out {
        println!("{line}");
    }
    println!("--- nodejs output (normalised) ---");
    for line in &js_out {
        println!("{line}");
    }

    std::process::exit(if matched { 0 } else { 1 });
}

fn normalise(raw: &str) -> Vec<String> {
    let ansi = regex::Regex::new(r"\x1b\[[0-9;]*m").unwrap();
    let echo_loc = regex::Regex::new(r"main\.gleam:\d+").unwrap();
    let value_shape = regex::Regex::new(
        r#"^-?\d+$|^-?\d+\.\d+$|^".*"$|^(True|False)$|^\[.*\]$|^#\(.*\)$|^<<.*>>$|^[A-Z][A-Za-z0-9_]*(\(.*\))?$"#,
    )
    .unwrap();
    let whole_float = regex::Regex::new(r"^(-?\d+)\.0$").unwrap();

    let mut lines = Vec::new();
    let mut in_warning = false;

    for line in raw.lines() {
        let stripped = ansi.replace_all(line, "").into_owned();

        if in_warning {
            if stripped.trim_end().is_empty() {
                in_warning = false;
            }
            continue;
        }
        if stripped.starts_with("warning:") {
            in_warning = true;
            continue;
        }

        if echo_loc.is_match(&stripped) {
            continue;
        }

        if value_shape.is_match(&stripped) {
            let canonical = whole_float.replace_all(&stripped, "$1").into_owned();
            lines.push(canonical.trim_end().to_string());
        }
    }
    lines
}
