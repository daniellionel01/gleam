// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Gleam contributors

// F-6: Erlang code generation panics ("variable not in scope",
// erlang.rs local_var_name) when an immediately-applied anonymous
// function's parameter is shadowed by a `let` in one case clause's body
// and referenced by LATER clauses. JavaScript codegen accepts this.
// Found by gleam-smith seed 2 (third generated program ever).
pub fn main() {
  echo fn(v) { case 1 {
      2 -> {
        let v = 3
        0
      }
      1 -> v
      _ -> v
    } }(9)
}
