// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Gleam contributors

#![no_main]

use fuzzing_core::generator::Module;
use libfuzzer_sys::arbitrary::Unstructured;
use libfuzzer_sys::fuzz_target;

fuzz_target!(|data: &[u8]| {
    let mut u = Unstructured::new(data);
    let Ok(module) = u.arbitrary::<Module>() else {
        return;
    };
    let src = module.to_source();
    match fuzzing_core::probe::probe_source(&src) {
        fuzzing_core::probe::ProbeOutcome::Compiled { .. } => {}
        other => panic!("fuzzing-core generated a non-compiling program ({other}):\n{src}"),
    }
});
