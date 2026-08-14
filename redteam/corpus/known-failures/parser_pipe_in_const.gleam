// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Gleam contributors

// F-5: parser panics on a pipeline operator inside a constant definition.
// parse.rs `constant_binop_reduction`: token_to_binop(`|>`).expect() is
// unreachable-by-assumption but reachable from source. Found by the
// compile_all_targets fuzz target on the VPS (~2 CPU-hours in).
const b = 1 |> 2
