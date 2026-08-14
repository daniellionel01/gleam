<!--
  SPDX-License-Identifier: Apache-2.0
  SPDX-FileCopyrightText: 2026 The Gleam contributors
-->

# Gleam Compiler Red Team Program

> Working document. Owns the methodology, the decisions, the tooling map,
> and the running status of the adversarial testing effort for the Gleam
> compiler (fork: `daniellionel01/gleam`).
>
> **Journal**: [`findings.md`](findings.md) — everything the tooling has
> surfaced so far, with classifications. Read it before duplicating work.

## Decisions (locked 2026-08-14)

| Question | Decision |
|---|---|
| Scope | **Compiler only** (`compiler-core`: parser, analyser/typer, exhaustiveness, both codegens). Formatter & LSP out of scope for now. |
| Upstreaming | Not intended; everything stays fork-local. |
| Compute | Local hardware, manually driven campaigns. CI integration later if it proves out. |
| Generator language | **Rust** (direct access to `gleam-core` internals). |
| Fuzzing engine | libFuzzer via `cargo-fuzz` (nightly). Corpus replay runs on stable via `cargo test`. |

## Threat model (from issue tracker + git history sweep, 2024-06 → 2026-08)

Ranked by frequency × severity. "Hot modules" is where red team budget concentrates.

| # | Class | Examples from history | Hot modules |
|---|-------|-----------------------|-------------|
| 1 | Case/pattern → decision-tree **miscompile (JS)** | gleam-lang/gleam#6168 (string prefixes, **open** at adoption time), #5743; `case`+`if`+`instanceof` wrongness | `src/javascript/decision.rs`, `src/erlang/pattern.rs`, `src/exhaustiveness/` |
| 2 | **Hygiene/shadowing**: invalid/wrong names emitted | shadowed names leaking scope in JS; invalid JS when shadowing prelude names (v1.1); shadowing in bit patterns (v1.6); duplicate `let` after shadowing (v1.18); constructor named `Number` breaks output | JS expression/decision codegen name mangling, `src/erlang.rs` |
| 3 | **Compiler panics** | panics on bit array patterns; `UtfCodepoint` reaching codegen; variant inference; stack overflow on large pattern matches; exhaustiveness crashes | `src/parse/`, `src/analyse/`, `src/type_/`, `src/exhaustiveness/` |
| 4 | **Bit array corner cases** | zero-width segments; unaligned arrays; 16-bit float rounding & -0.0; wrong slice lengths | `src/bit_array.rs`, both codegens |
| 5 | **Cross-target semantic drift** | `echo` of Infinity/NaN; tuple echo formatting; `Dict` equality; aliased-variant equality | JS prelude/runtime, `src/erlang/echo.rs`, equality codegen |
| 6 | **Evaluation order / block lifting** | division args evaluated in wrong order on Erlang; blocks lifted wrongly in pipelines; missing `begin/end` wraps | `src/erlang.rs`, pipeline codegen |
| 7 | **Constants & compile-time evaluation** | cross-module constant alias miscompiled in string concat (Erlang); constants missing from JS when only used in bit array sizes | `src/analyse/`, constant codegen |
| 8 | **Invalid-but-parseable syntax accepted** | `"panic as"` followed by nonsensical syntax compiling | `src/parse/`, `src/analyse/` |

## The method: generation ladder × oracle ladder

### Generation (what we feed the compiler)

- **L0 — byte fuzzing of the parser** (`parse_only` fuzz target). Cheap, immediate.
- **L1 — grammar-aware generation/mutation.** Parse-valid but possibly type-invalid programs that stress the analyser's error paths. Candidate tools: Grammarinator/Nautilus-style generation, tree-sitter-gleam subtree mutation. *Not built yet — see roadmap.*
- **L2 — type-directed generation ("gleam-smith").** Well-typed-by-construction programs, modelled on **wasm-smith**: deterministic from seed, `Arbitrary`-driven, fuel/size-bounded. The single highest-leverage artifact of this program. *Not built yet.*
- **L3 — typed-AST mutation (Fuzzilli lesson).** Mutate at a level where mutations preserve validity; splice equal-typed subtrees, reorder clauses, rename bindings.
- **L4 — bounded enumeration.** For narrow sublanguages that historically break (case clause matrices over small alphabets; identifier-collision scenarios), *enumerate* rather than sample. Enumeration gives full coverage where randomness gives anecdotes.

### Oracles (how we know it went wrong)

1. **Crash oracle** — the compiler must never panic, on any input. *Live now* (`probe_*`, fuzz targets, corpus replay).
2. **Compile-time differential oracle** — same source must be accepted/rejected consistently for both targets (modulo documented target limitations).
3. **Execution differential oracle** — compiled Erlang and JavaScript must produce identical observable output. *Live now* (`bin/diff-run.sh`), requires the divergence spec below to interpret results.
4. **Metamorphic oracle** — semantics-preserving transforms (alpha-renaming, clause reordering, redundant catch-all clauses, identity wrapping) must not change observable output. Directly targets classes 1, 2, 6. *Not built yet.*
5. **Self-consistency oracles** — emitted JS must parse (`node --check`); emitted Erlang must compile (`erlc`); TS declarations must typecheck. Catches the entire "invalid code generated" family without needing semantics.
6. **(Aspirational) model-based & translation-validation oracles** — naive pattern-match evaluator as ground truth for the decision-tree compilers; alive2-style per-pass validation. Parked.

## What exists today (layout)

```
compiler-core/src/redteam.rs        Probe API inside gleam-core. Contract:
                                    the compiler never panics on any input.
                                    Also hosts the stable-CI corpus replay test.
redteam/
├── README.md                       This document.
├── findings.md                     Findings journal (see F-1..F-4).
├── corpus/                         Seeds covering every historical bug class.
│                                     Replay: cargo test -p gleam-core redteam
│                                     Rule: everything here must be panic-free.
│                                     (Convention when needed: corpus/known-failures/
│                                      for minimized repros of OPEN bugs.)
├── bin/diff-run.sh                 Differential runner: one module with
│                                     `pub fn main`, compiled+run on Erlang and
│                                     Node.js, outputs diffed.
│                                     `--interesting` = reducer-compatible
│                                     exit-code mode (0 == divergence found).
├── ops/                            VPS automation (bare-metal/systemd):
│                                     setup.sh one-command provisioning,
│                                     fuzz-loop.service + daily sync timer,
│                                     crash-artifact inbox. See ops/README.md.
fuzz/                               cargo-fuzz crate (own workspace, nightly;
│                                     conventional root location).
└── fuzz_targets/
    ├── parse_only.rs               L0: raw bytes -> parser. Panic == bug.
    └── compile_all_targets.rs      L0/L1: bytes -> parse, analyse, codegen
                                      for JS + TS decls + Erlang. Panic == bug.
```

## How to run

```sh
# Stable: replay the seed corpus through parse->analyse->codegen(x2 targets)
cargo test -p gleam-core redteam          # fails iff a probe panicked

# Nightly, coverage-guided fuzzing (from the REPOSITORY ROOT)
cargo +nightly fuzz run parse_only                          # fast parser robustness
cargo +nightly fuzz run compile_all_targets                 # full-pipeline crash hunting
#   -- seeds from the redteam corpus:
cargo +nightly fuzz run compile_all_targets redteam/corpus
#   -- find a crash? repro lands in fuzz/artifacts/<target>/

# Differential behaviour check for one program (needs erl + node):
./redteam/bin/diff-run.sh redteam/corpus/string_prefix_case.gleam
./redteam/bin/diff-run.sh --interesting some_suspect.gleam ; echo $?
```

## Target divergence spec (DRAFT — the interpretive lens for oracle 3)

Divergences below are *documented platform semantics*, not bugs. Anything
else is a reportable finding. Keep this list explicit and tested.

| Area | Erlang target | JavaScript target | Handling |
|---|---|---|---|
| `Int` width | Arbitrary precision | IEEE-754 double (integers > 2^53 lose precision; compiler warns) | Generators avoid literals outside ±2^53 unless probing that boundary |
| Float printing | Erlang float formatting | JS `Number#toString` (incl. `Infinity`, `NaN`) | Known-divergent; historical bugs here |
| `echo` rendering | BEAM term style | prelude `echo.mjs` | Tuple formatting known inconsistent historically |
| Unicode | UTF-8 binaries, codepoint semantics | UTF-16 strings, grapheme handling in prelude | Normalize before diffing |
| Bit arrays | Native BEAM binaries | prelude `BitArray` implementation | Unaligned reads historically buggy |
| Process/panic effects | `exit` semantics | thrown exceptions | Compare exit codes, not messages |

## Roadmap

- [x] **P0 — foundations**: probe API in `gleam-core`; seed corpus mapped to bug classes; stable corpus replay test; dual-target differential runner; cargo-fuzz crate with parser + full-pipeline targets.
  - *Validation result 2026-08-14*: corpus replay green (11/11 seeds panic-free); diff-run reproduces open #6168 (F-1) and surfaced candidate JS bit-array divergence (F-2) — see findings.md; first fuzz sprints clean (836k parse runs / 174k full-pipeline runs, no crashes).
- [ ] **P1 — first harvest**: multi-hour `compile_all_targets` campaign, seeded from `corpus/`; triage, minimize (add `treereduce` + an exact interestingness script — `diff-run.sh --interesting` is the scaffold), isolate F-2/F-3 from findings.md, file findings in fork, codify each fix as corpus entry.
- [x] **P1-ops — continuous running**: `redteam/ops/` — one-command VPS provisioning, systemd fuzz loop + daily sync/rebuild/corpus-maintenance timer, deduped crash-artifact inbox.
- [ ] **P1.5 — self-consistency gates**: post-codegen `node --check` / `tsc --noEmit` / `erlc` checks on generated artifacts (cheap, kills "invalid code" class).
- [ ] **P2 — gleam-smith v1**: deterministic type-directed generator (wasm-smith-style, `Arbitrary`), expression/core subset; drive differential runner with generated `main`s.
- [ ] **P2.5 — bounded enumeration campaigns**: case-clause matrices; identifier-collision dictionary (prelude names, JS/Erlang keywords, `constructor`, `Number`, …).
- [ ] **P3 — metamorphic suite**: alpha-renaming + clause reordering + redundant clause injection over corpus and generated programs, diffing both targets.
- [ ] **P3.5 — typed-AST mutation engine** (L3).
- [ ] **P4 — governance**: metrics (grammar-production coverage of generator; branch coverage over `decision.rs`/`exhaustiveness/` from generated tests; panic trend; mismatch rate); scheduled long-running campaigns; bug-to-corpus pipeline standing rule: *no finding closes until a minimized repro is a permanent corpus entry*.

## Anti-goals / honesty notes

- Generator bias is real: we find what we generate. Countermeasure: mutate real code (later: `test/language`, community packages), not only synthetic programs, and track grammar coverage metrics.
- The interestingness test for reducers must be *exact*; a sloppy predicate silently throws away real bugs.
- Divergence blindness: without the spec above, oracle 3 produces false positives. When in doubt, report — misclassification is worse than noise.
- No snapshot-of-generated-code assertions in red team tooling: we want *behavioural* oracles, not churn.
- Not pursuing full formal verification. alive2-style translation validation is the parked endgame for individual passes, not a near-term goal.

## Prior art this draws on

Csmith (differential oracle + UB-free generation — easy mode for us thanks to the type system), wasm-smith (design template for `gleam-smith`), Fuzzilli (mutate at validity-preserving IL), Grammarinator/Nautilus (grammar-driven generation), Orion/EMI (metamorphic relations), alive2 (translation validation), treereduce (syntax-aware minimization), OSS-Fuzz (if/when continuous infra is wanted).
