// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Gleam contributors

// F-8: Erlang code generation panics ("variable not in scope",
// erlang.rs local_var_name) when a clause with an alias pattern whose
// inner literal ALSO appears in an earlier clause's alternatives has its
// own var alternative. JavaScript codegen accepts this.
// Found by gleam-smith (fuzz artifact crash-23b40773…), minimized by hand.
pub fn main() {
  echo case [7] {
    [2] | [] -> [3, 10]
    [] as whole | whole -> whole
    _ -> []
  }
}
