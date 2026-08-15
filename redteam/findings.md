<!--
  SPDX-License-Identifier: Apache-2.0
  SPDX-FileCopyrightText: 2026 The Gleam contributors
-->

# Red Team Findings Log

> Append-only journal of what the tooling surfaces. Each entry: seed/input,
> classification, and follow-up status. Classifications:
> `known-open-bug`, `candidate-new-bug` (needs isolation + confirmation),
> `confirmed-new-bug` (verified against the REAL build pipeline),
> `probe-artifact` (reproduces only in our harness, not the real pipeline),
> `documented-divergence` (added to the divergence spec, not a bug),
> `runner-noise` (tooling artifact, fixed in tooling).

> **Version scope (2026-08-14)**: every finding here reproduces on
> upstream **main** @ `7e623aa83` (81 commits after v1.18.0, V2-era
> development). The **1.18.1 release** handles every fixture gracefully
> (user-verified): F-5 yields a proper syntax error, F-7..F-11 compile
> and run correctly. These are UNRELEASED-main regressions — catching
> them pre-release is exactly the point of continuous red teaming, but
> they are NOT bugs in any shipped version, and snippets must always be
> labeled with the compiler version they were found on.
>
> **⚠ Pipeline-fidelity incident (2026-08-14)**: an early version of the
> probe ran the *disabled* inliner before codegen, producing findings F-6
> and F-10 that never reproduce on the real compiler (a user check on
> gleam 1.18.1 caught it). The probe now mirrors the real pipeline exactly
> (no inlining; see gleam-lang/gleam#5010). **Rule: every crash finding
> must be verified against the real `gleam` CLI before being called
> `confirmed-new-bug`.** All known-failures fixtures were re-verified
> against the real CLI on 2026-08-14; statuses below reflect that.

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

## 2026-08-14 — F-11 — Erlang codegen panic: guarded alternative string prefixes

- **Found by**: `smith_compile` sprint (artifact `crash-30c0819f…`).
- **Minimal repro**
  (`corpus/known-failures/erlang_guarded_alternative_string_prefix.gleam`):
  ```gleam
  pub fn main() {
    echo case "ab" {
      "bc" <> constructor | "a" <> constructor -> "ab"
      "ab" <> rest | "" <> rest if rest == "" -> rest
      _ -> ""
    }
  }
  ```
- **Trigger**: the string sibling of F-7 — a GUARDED alternative
  string-prefix clause following another alternative string clause.
- **Family summary (updated)**: F-7/F-8/F-9/F-11 are the REAL bug class —
  alternative patterns after earlier clauses lose guard/body variable
  registrations in the Erlang decision-tree compiler (verified on the real
  pipeline; list AND string subjects). F-6/F-10 looked like an
  anonymous-function branch of the same crash but turned out to be
  inliner-only (`probe-artifact`). gleam-smith suppressions now: no
  alternatives on list subjects (F-7..F-9), no guards on alternative
  clauses (F-7/F-11), no aliases on alternative clauses (F-8).
- **Regression source (bisected 2026-08-14)**: introduced by commit
  `f366e99a` — "omit unreachable case clauses in Erlang codegen",
  PR [gleam-lang/gleam#5991](https://github.com/gleam-lang/gleam/pull/5991)
  by `jackprogramsjp`, merged 2026-08-01. Verified by clean `git bisect`
  between `v1.18.1` (good) and `7e623aa83` (bad): parent `2850adecd`
  compiles all four; `f366e99a` panics on all four; `v1.18.0` also good
  (sole introducer, no older instance). Root cause: the PR feeds
  `compiled_case.unreachable` (from `exhaustiveness.rs`) into Erlang
  codegen and **skips** any clause/alternative flagged unreachable. When
  a skipped pattern is the one that binds a variable the guard/body
  uses, that variable is never registered → `erlang.rs:512` panics
  "variable not in scope". JavaScript codegen does not skip on
  `unreachable`, so JS compiles fine (Erlang-only).
- **Status**: `confirmed-new-bug` — VERIFIED against the real CLI
  (2026-08-14): `gleam build --target erlang` aborts with
  `error: Fatal compiler bug! … variable not in scope`.

## 2026-08-14 — F-10 — Erlang codegen panic: anon fn param used twice (the headline repro)

- **Found by**: `smith_compile` sprint (artifact `crash-8c603e38…`).
- **Minimal repro** (`corpus/known-failures/erlang_anon_param_used_twice.gleam`):
  ```gleam
  pub fn main() {
    echo fn(v) { v + v }(10)
  }
  ```
- **Trigger**: an immediately-applied anonymous function whose parameter is
  referenced TWICE in its body (`v + v`, `v <= v`, …). Single use is fine.
  No case, no shadowing, no alternatives. The inliner presumably consumes
  the param's registration on first substitution and loses it by the
  second. JavaScript codegen is unaffected.
- **Severity**: HIGH for the family — this is ordinary-looking user code,
  not an adversarial shape. Any Gleam user can hit it on the Erlang target.
- **Severity note**: the "ordinary user code" framing was WRONG — see the
  reclassification below.
- **Status**: `probe-artifact` (reclassified 2026-08-14). Verified against
  the real CLI: `gleam run --target erlang` compiles and prints 20 (gleam
  1.18.1 AND repo HEAD). The crash requires the disabled inliner
  (gleam-lang/gleam#5010) in the pipeline, which the real compiler never
  runs. Latent inliner bug, not a user-facing bug today. gleam-smith
  anon-fn generation re-enabled accordingly.

## 2026-08-14 — F-9 — Erlang codegen panic: alternatives after cons pattern (purest form)

- **Found by**: `smith_compile` sprint (artifact `crash-a1a29e3f…`).
- **Minimal repro**
  (`corpus/known-failures/erlang_alternatives_after_cons_pattern.gleam`):
  ```gleam
  pub fn main() {
    echo case [5, 3] {
      [_, ..] -> [0]
      [9, ..rest] | rest -> rest
      _ -> []
    }
  }
  ```
- **Trigger**: a list-cons pattern clause, then an ALTERNATIVES clause
  whose bound variable is used in the body. No guard, no alias, no
  shadowing required — the purest form of the F-7/F-8 family. Same panic
  site (`erlang.rs:512`). String-prefix alternatives are NOT affected.
- **Family summary (F-7/F-8/F-9)**: three minimal repros of one bug class —
  alternative list patterns following other list clauses lose variable
  registrations in the Erlang decision-tree compiler. Suppression in
  gleam-smith: no alternatives on list subjects at all until fixed.
- **Status**: `confirmed-new-bug` — VERIFIED against the real CLI
  (2026-08-14): `gleam build --target erlang` aborts with
  `error: Fatal compiler bug! … variable not in scope`. gleam-smith
  suppression (no alternatives on list subjects) remains until fixed.

## 2026-08-14 — F-8 — Erlang codegen panic: alias + alternative overlap

- **Found by**: `smith_compile` sprint (artifact `crash-23b40773…`),
  hand-minimized through ~8 bisection rounds.
- **Minimal repro**
  (`corpus/known-failures/erlang_alias_alternative_overlap.gleam`):
  ```gleam
  pub fn main() {
    echo case [7] {
      [2] | [] -> [3, 10]
      [] as whole | whole -> whole
      _ -> []
    }
  }
  ```
- **Trigger**: clause 1 has alternatives including `[]`; clause 2 aliases
  `[]` (`[] as whole`) AND has a var alternative. Changing the alias's
  inner literal, removing clause 1's `[]` alternative, or removing the
  alias each avoids the crash. Same panic site as F-6/F-7
  (`erlang.rs:512`), third distinct trigger — this is a systematic
  scope-registration bug class in Erlang decision-tree compilation, not
  three isolated bugs.
- **Status**: `confirmed-new-bug` — VERIFIED against the real CLI
  (2026-08-14): `gleam build --target erlang` aborts with
  `error: Fatal compiler bug! … variable not in scope`. gleam-smith
  alias-on-alternatives gating remains until fixed.

## 2026-08-14 — F-7 — Erlang codegen panic: guarded alternative list patterns

- **Found by**: `smith_compile` fuzz sprint on gleam-smith-generated
  programs (artifact `crash-2b8a1feb…`), minutes after F-6 suppression
  landed. Hand-minimized through ~10 bisection rounds.
- **Minimal repro**
  (`corpus/known-failures/erlang_guarded_alternative_list_pattern.gleam`):
  ```gleam
  pub fn main() {
    echo case [10, 3] {
      [_] -> 1
      [a] | [a, ..] if a > 0 -> 2
      _ -> 0
    }
  }
  ```
- **Trigger**: an exact-length list pattern clause (`[_]`), followed by a
  GUARDED ALTERNATIVE list pattern (`[a] | [a, ..]`) whose guard
  references the pattern-bound variable. All three elements required:
  exact-length clause first, alternative (`|`), guard. Dropping any one
  avoids the crash.
- **Root cause (surface)**: same panic site as F-6 (`erlang.rs:512`
  `local_var_name`) — the Erlang decision-tree compiler loses the guard
  variable's scope registration for this clause arrangement. Distinct
  trigger from F-6, likely shared root cause in scope tracking.
- **Targets**: JavaScript compiles cleanly; only Erlang codegen panics.
- **Classification**: `candidate-new-bug`, crash class (#3), decision-tree
  compilation (class #1 territory). gleam-smith suppression: no guards on
  alternative list patterns until fixed.
- **Status**: `confirmed-new-bug` — VERIFIED against the real CLI
  (2026-08-14): `gleam build --target erlang` aborts with
  `error: Fatal compiler bug! … variable not in scope`.

## 2026-08-14 — F-6 — gleam-smith's first kill: Erlang codegen panic on shadowed anon-fn param

- **Found by**: `gleam-smith` seed 2 (the generator's third program ever),
  during its own validation run. Seeds 16 and 42 hit the same bug.
- **Minimal repro** (`corpus/known-failures/erlang_shadowed_anon_param.gleam`):
  ```gleam
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
  ```
- **Trigger**: an immediately-applied anonymous function whose parameter is
  shadowed by a `let` in one case clause's body, while LATER clauses
  (a literal clause and the catch-all) reference the parameter. Requires
  the full 3-clause ensemble — dropping either later clause avoids it.
- **Root cause (surface)**: `erlang.rs:512` `local_var_name` — the Erlang
  codegen tracks variables by origin span; the shadowed anon-fn param's
  registration is lost when compiling the later clauses. Panic message:
  "variable not in scope", which the code itself documents as "most
  likely the result of a bug in the compiler".
- **Targets**: JavaScript + TypeScript compile cleanly (probe order); only
  Erlang codegen panics.
- **Tracker check** (2026-08-14): no matching issue.
- **Classification**: `candidate-new-bug`, crash class (#3), Erlang
  codegen, hygiene-adjacent (class #2 territory: name/scope tracking).
  This is the exact intersection of classes 2 and 3 the red team program
  predicted would be hottest.
- **Status**: `probe-artifact` (reclassified 2026-08-14). The anon-fn
  inlining pass is DISABLED in the real build pipeline
  (gleam-lang/gleam#5010); this crash only occurs when the disabled
  inliner's output is fed to Erlang codegen, which the real compiler never
  does. Does NOT reproduce on gleam 1.18.1 or repo HEAD via the real CLI.
  Still a latent bug in the disabled inliner — worth an upstream note if
  inlining is ever re-enabled, but NOT a user-facing bug today.

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
- **Follow-up**: added to the known-bug registry so fuzz harnesses skip it.
