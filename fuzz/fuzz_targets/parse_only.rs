// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Gleam contributors
//
// Fuzz target 0 (cheap, fast): the lexer and parser must never panic,
// on any byte sequence. Panics here abort before analysis to keep
// the signal attributable.
#![no_main]

use libfuzzer_sys::fuzz_target;

fuzz_target!(|data: &[u8]| {
    let _ = redteam_probe::probe_parse_bytes(data);
});
