// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Gleam contributors
//
// Fuzz target 2 (type-directed): raw bytes drive gleam-smith to build a
// well-typed Gleam module; the module is pushed through the full pipeline
// (parse -> analyse x2 targets -> JS + TS + Erlang codegen). This is the
// target that reaches the codegen bug classes (decision trees, hygiene)
// that text-mutation fuzzing almost never reaches.
//
// Two panic kinds are caught:
// - compiler panics on generated programs: COMPILER BUGS. libFuzzer's
//   panic hook aborts before any catch_unwind can fire, so these always
//   become artifacts; known-bug shapes (F-5, F-6) are suppressed in the
//   generator itself (see Ctx::protected in gleam-smith), not filtered
//   here.
// - generated program doesn't compile: GENERATOR BUGS (gleam-smith's
//   valid-by-construction contract), raised below.
#![no_main]

use gleam_smith::Module;
use libfuzzer_sys::arbitrary::Unstructured;
use libfuzzer_sys::fuzz_target;

fuzz_target!(|data: &[u8]| {
    let mut u = Unstructured::new(data);
    let Ok(module) = u.arbitrary::<Module>() else {
        return;
    };
    let src = module.to_source();
    match redteam_probe::probe_source(&src) {
        redteam_probe::ProbeOutcome::Compiled { .. } => {}
        other => panic!("gleam-smith generated non-compiling program ({other}):\n{src}"),
    }
});
