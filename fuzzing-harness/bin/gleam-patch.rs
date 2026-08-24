// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Gleam contributors

//! Apply patches for known Gleam/Erlang issues against this checkout.
//!
//! Each patch in `fuzzing-harness/patches/` is a `git apply`able diff plus a
//! `.toml` metadata file. The metadata records the sha256 of every source
//! file the patch touches, captured at the time the patch was captured.
//!
//! On `apply`, every patch is checked:
//!   - If the recorded hashes still match the current source, the patch
//!     applies cleanly and the local Gleam is rebuilt.
//!   - If a hash doesn't match, the file has changed upstream (PR merged,
//!     refactor, etc.). The patch is skipped and the metadata is left in
//!     place as a signal that the issue may now be fixed upstream.
//!
//! Usage:
//!   gleam-patch apply               apply all patches with matching hashes
//!   gleam-patch status              show which patches apply and which don't
//!   gleam-patch build               rebuild the local Gleam binary
//!
//! `cd fuzzing-harness && cargo run --bin gleam-patch -- <command>`

use std::collections::BTreeMap;
use std::fs;
use std::path::{Path, PathBuf};
use std::process::Command;

#[derive(serde::Deserialize)]
struct PatchEntry {
    issue: String,
    pr: String,
    description: String,
    patch: String,
    expected_hash: Vec<ExpectedHash>,
}

#[derive(serde::Deserialize)]
struct ExpectedHash {
    path: String,
    sha256: String,
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    match args.get(1).map(String::as_str) {
        Some("apply") => apply_all(),
        Some("status") => status(),
        Some("build") => build(),
        _ => {
            eprintln!("usage:\n  gleam-patch apply\n  gleam-patch status\n  gleam-patch build");
            std::process::exit(2);
        }
    }
}

fn patches_dir() -> PathBuf {
    // Walk upward from CWD looking for a `fuzzing-harness/patches` dir.
    let mut dir = std::env::current_dir().unwrap_or_else(|_| PathBuf::from("."));
    loop {
        let candidate = dir.join("fuzzing-harness").join("patches");
        if candidate.is_dir() {
            return candidate;
        }
        if !dir.pop() {
            return PathBuf::from("patches");
        }
    }
}

fn repo_root() -> PathBuf {
    // Walk upward from CWD looking for a Cargo.toml with a workspace section.
    let mut dir = std::env::current_dir().unwrap_or_else(|_| PathBuf::from("."));
    loop {
        if dir.join("Cargo.toml").is_file() && dir.join("compiler-core").is_dir() {
            return dir;
        }
        if !dir.pop() {
            return PathBuf::from("..");
        }
    }
}

fn load_patches() -> Vec<(String, PatchEntry)> {
    let mut out = Vec::new();
    let dir = patches_dir();
    let entries = match fs::read_dir(&dir) {
        Ok(e) => e,
        Err(e) => {
            eprintln!("error: cannot read {}: {e}", dir.display());
            return out;
        }
    };
    for entry in entries.flatten() {
        let path = entry.path();
        if path.extension().and_then(|s| s.to_str()) != Some("toml") {
            continue;
        }
        let raw = match fs::read_to_string(&path) {
            Ok(s) => s,
            Err(e) => {
                eprintln!("error: cannot read {}: {e}", path.display());
                continue;
            }
        };
        let meta: PatchEntry = match toml::from_str(&raw) {
            Ok(m) => m,
            Err(e) => {
                eprintln!("error: cannot parse {}: {e}", path.display());
                continue;
            }
        };
        let name = path.file_stem().unwrap().to_string_lossy().into_owned();
        out.push((name, meta));
    }
    out
}

fn hash_file(path: &Path) -> Option<String> {
    use sha2::Digest;
    let bytes = fs::read(path).ok()?;
    let digest = sha2::Sha256::digest(&bytes);
    Some(format!("{:x}", digest))
}

fn check_patch(entry: &PatchEntry) -> Result<(), String> {
    let root = repo_root();
    for h in &entry.expected_hash {
        let abs = root.join(&h.path);
        let actual = match hash_file(&abs) {
            Some(s) => s,
            None => return Err(format!("{}: cannot read", h.path)),
        };
        if actual != h.sha256 {
            return Err(format!(
                "{}: hash mismatch\n      expected {}\n      actual   {}\n      upstream may have changed; patch likely no longer needed",
                h.path, h.sha256, actual
            ));
        }
    }
    Ok(())
}

fn apply_patch(entry: &PatchEntry) -> Result<(), String> {
    let patch_path = patches_dir().join(&entry.patch);
    let check = Command::new("git")
        .args(["apply", "--check"])
        .arg(&patch_path)
        .current_dir(repo_root())
        .output()
        .map_err(|e| format!("git apply --check failed to start: {e}"))?;
    if !check.status.success() {
        let stderr = String::from_utf8_lossy(&check.stderr);
        return Err(format!(
            "patch is malformed and cannot apply (run `git apply --check {}` to see full error)\n{}",
            patch_path.display(),
            stderr.trim_end()
        ));
    }
    let status = Command::new("git")
        .arg("apply")
        .arg(&patch_path)
        .current_dir(repo_root())
        .status()
        .map_err(|e| format!("git apply failed to start: {e}"))?;
    if !status.success() {
        return Err("git apply failed".into());
    }
    Ok(())
}

fn build() {
    let root = repo_root();
    eprintln!("[gleam-patch] building gleam at {}", root.display());
    let status = Command::new("cargo")
        .args(["build", "--release", "-p", "gleam-cli"])
        .current_dir(&root)
        .status()
        .expect("cargo build failed to start");
    if !status.success() {
        std::process::exit(status.code().unwrap_or(1));
    }
}

fn status() {
    let patches = load_patches();
    if patches.is_empty() {
        eprintln!("[gleam-patch] no patches found in {}", patches_dir().display());
        return;
    }
    for (name, entry) in patches {
        match check_patch(&entry) {
            Ok(()) => println!("[gleam-patch] {name}: hashes match (would apply)"),
            Err(e) => println!("[gleam-patch] {name}: {e}"),
        }
    }
}

fn apply_all() {
    let patches = load_patches();
    if patches.is_empty() {
        eprintln!("[gleam-patch] no patches found in {}", patches_dir().display());
        return;
    }
    let mut applied = 0;
    let mut resolved = 0;
    let mut broken = 0;
    for (name, entry) in &patches {
        match check_patch(entry) {
            Ok(()) => match apply_patch(entry) {
                Ok(()) => {
                    println!("[gleam-patch] applied {name} ({})", entry.pr);
                    applied += 1;
                }
                Err(e) => {
                    eprintln!("[gleam-patch] BROKEN {name}: {e}");
                    broken += 1;
                }
            },
            Err(e) => {
                println!("[gleam-patch] resolved {name}: {e}");
                resolved += 1;
            }
        }
    }
    if applied > 0 {
        build();
    }
    println!(
        "[gleam-patch] done: {applied} applied, {resolved} resolved (upstream may have changed), {broken} broken"
    );
}