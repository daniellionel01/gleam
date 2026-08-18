// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Gleam contributors

//! Differential-oracle CLI.
//!
//! Subcommands:
//!   redteam-diff compare [--interesting] <erlang.raw> <js.raw> <erl-status> <js-status>
//!     Normalises both raw outputs, prints the report, and exits 0 iff the
//!     verdict is MATCH (or iff MISMATCH with --interesting). Report format
//!     is byte-compatible with the old redteam/bin/diff-run.sh so
//!     version-check.sh and smith-campaign.sh keep working untouched.
//!
//! The process spawning (gleam/erl/node, temp projects) stays in bash;
//! everything textual lives here so it can be unit tested.

use std::fmt::Write as _;
use std::process::exit;

use redteam_diff::normalise;

fn main() {
    let args: Vec<String> = std::env::args().collect();
    match args.get(1).map(String::as_str) {
        Some("compare") => compare(&args[2..]),
        _ => {
            eprintln!("usage: redteam-diff compare [--interesting] <erl.raw> <js.raw> <erl-status> <js-status>");
            exit(2)
        }
    }
}

fn compare(args: &[String]) -> ! {
    let mut interesting = false;
    let mut input: Option<String> = None;
    let mut rest = args;
    loop {
        match rest.first().map(String::as_str) {
            Some("--interesting") => {
                interesting = true;
                rest = &rest[1..];
            }
            Some("--input") if rest.len() >= 2 => {
                input = Some(rest[1].clone());
                rest = &rest[2..];
            }
            _ => break,
        }
    }
    if rest.len() != 4 {
        eprintln!("usage: redteam-diff compare [--interesting] [--input <path>] <erl.raw> <js.raw> <erl-status> <js-status>");
        exit(2)
    }
    let (erl_raw, js_raw, erl_status, js_status) = (&rest[0], &rest[1], &rest[2], &rest[3]);

    let erl_ok = erl_status == "0";
    let js_ok = js_status == "0";
    let erl_out = read_normalise(erl_raw);
    let js_out = read_normalise(js_raw);
    let verdict = if erl_ok && js_ok && erl_out == js_out {
        "MATCH"
    } else {
        "MISMATCH"
    };

    if interesting {
        // "interestingness test" for reducers: exit 0 iff there is a
        // divergence. No report in this mode (matches the old script).
        exit(if verdict == "MISMATCH" { 0 } else { 1 })
    }

    let mut report = String::new();
    let _ = writeln!(report, "=== redteam diff-run ===");
    if let Some(input) = &input {
        let _ = writeln!(report, "input:           {input}");
    }
    let _ = writeln!(report, "erlang status:   {erl_status}");
    let _ = writeln!(report, "nodejs status:   {js_status}");
    let _ = writeln!(report, "verdict:         {verdict}");
    let _ = writeln!(report, "--- erlang output (normalised) ---");
    for line in &erl_out {
        let _ = writeln!(report, "{line}");
    }
    let _ = writeln!(report, "--- nodejs output (normalised) ---");
    for line in &js_out {
        let _ = writeln!(report, "{line}");
    }
    if verdict == "MISMATCH" {
        let _ = writeln!(report, "--- raw diff (erlang | nodejs) ---");
        let _ = writeln!(report, "{}", raw_diff(erl_raw, js_raw));
    }
    print!("{report}");
    exit(if verdict == "MATCH" { 0 } else { 1 })
}

fn read_normalise(path: &str) -> Vec<String> {
    match std::fs::read(path) {
        Ok(bytes) => normalise(&String::from_utf8_lossy(&bytes)),
        Err(error) => {
            eprintln!("error: cannot read {path}: {error}");
            exit(2)
        }
    }
}

/// Best-effort diff of the two raw outputs, first 40 lines, mirroring the
/// old `diff ... | head -40`. Falls back to a "files differ" note if a
/// diff binary isn't available.
fn raw_diff(erl_raw: &str, js_raw: &str) -> String {
    let Ok(output) = std::process::Command::new("diff")
        .arg(erl_raw)
        .arg(js_raw)
        .output()
    else {
        return "  (diff unavailable)".to_string();
    };
    let text = String::from_utf8_lossy(&output.stdout);
    text.lines().take(40).collect::<Vec<_>>().join("\n")
}