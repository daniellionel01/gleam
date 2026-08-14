<!--
  SPDX-License-Identifier: Apache-2.0
  SPDX-FileCopyrightText: 2026 The Gleam contributors
-->

# Red Team Findings Log

> Append-only journal of what the tooling surfaces. Each entry: seed/input,
> classification, and follow-up status. Classifications:
> `known-open-bug`, `candidate-new-bug` (needs isolation + confirmation),
> `documented-divergence` (added to the divergence spec, not a bug),
> `runner-noise` (tooling artifact, fixed in tooling).

## 2026-08-14 — P0 tooling validation run (11 corpus seeds, diff-run)

### F-1 — `corpus/string_prefix_case.gleam` — string prefix patterns + guard
- **Observation**: `with_guard("ab", 1)` returns `2` on Erlang, `3` on Node.js.
- **Classification**: `known-open-bug` — reproduces gleam-lang/gleam#6168
  ("Gleam Javascript miscompiles some string pattern matches", open).
- **Significance**: seed #1 of the corpus reproduces an open, real
  miscompile. Differential runner + corpus design validated.
- **Status**: tracked upstream. Stays a permanent corpus + diff-run fixture
  upstream of the fix to prove it when it lands.

### F-2 — `corpus/bit_arrays.gleam` — 16-bit float + utf8 + trailing bits pattern
- **Observation**: `unpack(pack(5))` where the input is a 7-byte bit array
  built with a `:16-float` segment — the clause
  `<<x:16, _:16-float, _:utf8, _:8, _:bits>>` matches on Erlang (returns 5)
  but **falls through to the default clause on Node.js** (returns -1).
- **Classification**: `candidate-new-bug` — JavaScript bit-array pattern
  matching divergence. Consistent with the historical bug density in bit
  array codegen (zero-width segments, 16-bit float rounding, -0.0 encoding,
  unaligned reads).
- **Status**: NEEDS ISOLATION (reduce to minimal segment combination:
  16-float vs utf8 vs trailing `_:bits`, then check tracker for dupes).

### F-3 — `corpus/reserved_words.gleam` — custom type named `Record`
- **Observation**: Erlang codegen emits `-type record() :: ...`, which makes
  the Erlang compiler warn `local redefinition of built-in type: record()`.
  Compiles and runs correctly today.
- **Classification**: `candidate-new-bug` (hygiene class) — Erlang type-name
  mangling should avoid collision with Erlang built-in pseudo-types
  (`record`, possibly others). Silent breakage risk for dialyzer/tooling.
- **Status**: needs tracker dupe check + confirmation of practical impact.

### F-4 — `echo` of empty and non-UTF-8 bit arrays
- **Observation**: Erlang `echo` renders `<<>>` as `""` and valid-UTF-8 bit
  arrays as strings (`<<"a", 1>>` → `"a\u{0001}"`); JavaScript prints
  `<<>>` / `<<97, 1>>` structurally.
- **Classification**: `documented-divergence` candidate — echo rendering
  rules for bit arrays differ per target. If not already documented as
  rendering-specific behaviour, this is a parity gap worth an issue.
- **Status**: added to divergence spec draft (echo rendering row).

## Standing rules

- No finding is "closed" here without (a) classification, (b) a minimized
  repro in `corpus/`, and (c) for candidate-new-bugs: manual confirmation
  against the issue tracker. Dedup before reporting is mandatory.
- `candidate-new-bug` entries are **not** investigations yet — the P1 phase
  harvest will isolate them with the reducer pipeline.

## 2026-08-14 — F-5 — FIRST VPS HARVEST: parser panic on `|>` in constants

- **Found by**: `compile_all_targets` (and independently `parse_only`) on the
  VPS, ~2 CPU-hours in. Artifacts `d7da2e80…`, `09f2e4f9…`, `2bd1bab2…`.
- **Minimal repro** (one line, panics the whole compiler):
  ```gleam
  const b = 1 |> 2
  ```
- **Root cause**: `parse.rs:5220` — `constant_binop_reduction` calls
  `token_to_binop(&operator_token).expect(...)`. The constant-expression
  parser hands the pipe token to the reduction as if it were a binop;
  `token_to_binop` doesn't cover it. Unreachable-by-assumption, reachable
  from source. Same shape as historical "X made it to code generation"
  panics, but this one is in the *parser*: no valid-program input needed.
- **Tracker check** (2026-08-14): no issue matches "converted to binop".
- **Classification**: `candidate-new-bug`, crash class (#3). Severity
  moderate: any `|>` inside a `const` aborts compilation with a panic
  instead of an error message.
- **Regression fixture**: `corpus/known-failures/parser_pipe_in_const.gleam`
  (excluded from the panic-free corpus replay by directory convention).
- **Status**: CONFIRMED NEW. Awaiting decision on upstream report; fix is a
  one-line `expect` → graceful error, plus a parse-precedence audit for
  other non-binop tokens reaching the same reduction (e.g. check `&&`/`||`
  in consts and guard-only operators).
