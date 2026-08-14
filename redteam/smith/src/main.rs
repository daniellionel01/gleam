// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Gleam contributors

//! gleam-smith CLI: generate deterministic Gleam programs from seeds.
//!
//!   gleam-smith gen <seed>                print one program to stdout
//!   gleam-smith batch <dir> <start> <n>   write seed_<i>.gleam files

use gleam_smith::Module;

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let usage = "usage:\n  gleam-smith gen <seed>\n  gleam-smith batch <dir> <start-seed> <count>";
    match args.get(1).map(String::as_str) {
        Some("gen") => {
            let seed: u64 = args
                .get(2)
                .and_then(|s| s.parse().ok())
                .unwrap_or_else(|| {
                    eprintln!("{usage}");
                    std::process::exit(2)
                });
            print!("{}", Module::from_seed(seed).to_source());
        }
        Some("batch") => {
            let (Some(dir), Some(start), Some(count)) =
                (args.get(2), args.get(3), args.get(4))
            else {
                eprintln!("{usage}");
                std::process::exit(2);
            };
            let start: u64 = start.parse().expect("start seed");
            let count: u64 = count.parse().expect("count");
            std::fs::create_dir_all(dir).expect("create output dir");
            for seed in start..start + count {
                let src = Module::from_seed(seed).to_source();
                std::fs::write(format!("{dir}/seed_{seed}.gleam"), src).expect("write");
            }
            println!("wrote {count} programs to {dir}");
        }
        _ => {
            eprintln!("{usage}");
            std::process::exit(2);
        }
    }
}
