// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Gleam contributors

// F-9: Erlang code generation panics ("variable not in scope",
// erlang.rs local_var_name) when an alternatives list pattern follows a
// list-cons pattern clause and the alternative-bound variable is used in
// the clause body. No guard or alias needed — the purest form of the
// F-7/F-8 family. JavaScript codegen accepts this.
// Found by gleam-smith (fuzz artifact crash-a1a29e3f…), minimized by hand.
pub fn main() {
  echo case [5, 3] {
    [_, ..] -> [0]
    [9, ..rest] | rest -> rest
    _ -> []
  }
}
