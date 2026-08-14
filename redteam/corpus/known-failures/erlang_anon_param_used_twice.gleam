// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Gleam contributors

// F-10: Erlang code generation panics ("variable not in scope",
// erlang.rs local_var_name) when an immediately-applied anonymous
// function's parameter is referenced TWICE in its body. JavaScript
// codegen accepts this. This is ordinary-looking user code — the most
// user-visible repro of the F-6..F-10 family.
// Found by gleam-smith (fuzz artifact crash-8c603e38…), minimized by hand.
pub fn main() {
  echo fn(v) { v + v }(10)
}
