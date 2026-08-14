// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Gleam contributors

// F-7: Erlang code generation panics ("variable not in scope",
// erlang.rs local_var_name) when a guarded ALTERNATIVE list pattern
// follows an exact-length list pattern, and the guard references the
// pattern-bound variable. JavaScript codegen accepts this.
// Found by gleam-smith (fuzz artifact crash-2b8a1feb…), minimized by hand.
pub fn main() {
  echo case [10, 3] {
    [_] -> 1
    [a] | [a, ..] if a > 0 -> 2
    _ -> 0
  }
}
