// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Gleam contributors
//
// Fuzz target 1 (the workhorse): parse -> analyse -> codegen for BOTH
// targets (JavaScript + TypeScript declarations + Erlang). The contract
// is that the compiler never panics and never reaches codegen with an
// invalid internal state. Any panic here is a compiler bug; the fuzzer
// will save the reproducing input to artifacts/.
#![no_main]

use libfuzzer_sys::fuzz_target;

fuzz_target!(|data: &[u8]| {
    let _ = redteam_probe::probe_bytes(data);
});
