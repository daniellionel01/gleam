// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Gleam contributors

// F-11: Erlang code generation panics ("variable not in scope",
// erlang.rs local_var_name) when a GUARDED alternative string-prefix
// pattern follows another alternative string-prefix clause. The string
// sibling of list-family F-7. JavaScript codegen accepts this.
// Found by gleam-smith (fuzz artifact crash-30c0819f…), minimized by hand.
pub fn main() {
  echo case "ab" {
    "bc" <> constructor | "a" <> constructor -> "ab"
    "ab" <> rest | "" <> rest if rest == "" -> rest
    _ -> ""
  }
}
