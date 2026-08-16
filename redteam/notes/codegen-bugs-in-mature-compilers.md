# Codegen Bugs in Mature Compilers — Reference List

A curated set of real miscompilation / codegen-crash bugs in established,
well-resourced compilers — mostly targeting JavaScript. Compiled as
context for a blog post on Gleam red-teaming, to make the point that
codegen correctness is an unsolved problem even for the most mature
projects, and that finding these bugs is what a healthy compiler
project *does*, not a reliability signal.

---

## Erlang/OTP — same runtime Gleam targets

- **[#11088 — "Miscompilation"](https://github.com/erlang/otp/issues/11088)**
  (reported 2026-05, affected OTP 27.2.2)

  A wrong *optimization* in the BEAM VM: enabling or commenting out a
  debug `erlang:display(SessionPresent)` call changes the program's
  **result** (`session_present => true` vs `false`). Same code family
  and same runtime as Gleam's Erlang target — an optimization that
  silently produces wrong code depending on unrelated surrounding
  context. If it can happen to the BEAM after 30+ years, it can happen
  to anything compiling to BEAM.

---

## Solidity — optimizer + recursion miscompilations, this month, billions at stake

- **[Unsound Spill In Mutual Recursion Bug](https://www.soliditylang.org/blog/2026/07/09/unsound-spill-in-mutual-recursion-bug/)**
  (Solidity blog, 2026-07-09)

  The Yul optimizer's call-graph analysis misclassifies **mutually
  recursive functions as non-recursive**, causing the stack-to-memory
  "spilling" mechanism to incorrectly apply to them — sharing local
  variables across invocations. A recursion-related optimizer
  miscompilation, discovered May 2026, in a compiler where wrong
  bytecode can lose real money. Solidity has been around since 2014 and
  is audited continuously.

- **[Inheritance Order Reversal On Storage End Warning Bug](https://www.soliditylang.org/blog/2026/07/09/inheritance-order-reversal-on-storage-end-warning-bug/)**
  (Solidity blog, 2026-07-09)

  A *warning's* implementation reverses the C3-linearized inheritance
  list, and because that linearization drives decisions throughout the
  compiler, the reversal causes **miscompilations**. A diagnostic
  feature silently corrupting codegen — a perfect example of how
  intertwined and fragile this layer is.

- **[Solidity 0.8.36 Release Announcement](https://www.soliditylang.org/blog/2026/07/09/solidity-0.8.36-release-announcement)**
  (Solidity blog, 2026-07-09)

  The release notes for the version that fixes both of the above —
  useful for citing that these were shipped, security-grade fixes in a
  mature compiler in mid-2026.

---

## Babel — the most ubiquitous JS transpiler, silent wrong output

- **[#17282 — "Incorrect output when destructuring private property with duplicate properties and rest element"](https://github.com/babel/babel/issues/17282)**
  (reported 2025-04, fixed 2025-10)

  Babel — the transpiler that processes most of the JS ecosystem —
  emits `undefined` instead of `"a"` for a destructuring-with-rest
  pattern involving private fields. Pure JS-codegen silent wrong
  answer in the most widely-deployed JS compiler on Earth.

---

## Scala.js — the closest sibling project (functional language → JS)

- **[scala-js/scala-js #5131 — "Linker not noticing instance test changes"](https://github.com/scala-js/scala-js/issues/5131)**
  (closed in v1.19.0, 2025)

  Scala.js compiles a strongly-typed functional language to JavaScript
  — exactly Gleam's JS-target mission. It's mature (since 2013),
  maintained by a meticulous core team (sjrd), and it **still ships
  codegen/linker correctness bugs** a decade in. A good "this is the
  whole category, not a Gleam failing" exhibit.

---

## TypeScript — downlevel emit, the canonical long-lived codegen footgun

- **[TypeScript Handbook — Enums (const enum caveats)](https://www.typescriptlang.org/docs/handbook/enums.html)**

  TypeScript's downleveling (compiling modern JS/TS to older ES
  targets) is a well-known, long-lived source of codegen surprises —
  most famously `const enum`, whose codegen is fragile enough that the
  TypeScript handbook itself documents the pitfalls and the team added
  `--isolatedModules` / `--preserveConstEnums` to mitigate them. A
  mature, Microsoft-backed compiler whose *correct-by-construction*
  promise is specifically about types, not emit.

---

## Elm — the closest precedent (functional language → JS, ~10 years old, deliberately simple)

- **[#1367 — "Incoming ports that take unit as an argument causes a crash at runtime"](https://github.com/elm/compiler/issues/1367)**
  (closed)

  The most on-point example: a **JS codegen bug that compiles fine but
  crashes at runtime** — exactly the F-12 / F-13 failure mode. A port
  typed `(() -> msg) -> Sub msg` (taking unit / `()`) compiles with no
  error, but the generated JavaScript references `_Tuple0`, which is
  **undefined** → `ReferenceError: _Tuple0 is not defined` when the
  app loads. A perfectly well-typed Elm program produces JS that
  crashes the moment it runs. Found in a mature (at the time) 0.18-era
  compiler.

- **[#2072 — "Compiler crashes due to wrong extensible record annotation"](https://github.com/elm/compiler/issues/2072)**
  (open since 2020)

  A compiler **crash** (not just a wrong answer) on a wrong-but-plausible
  extensible-record annotation — the Elm analog of Gleam's F-5 / F-7
  crash class. The reporter's note is on-theme: *"Just playing around
  with Elm to see how good it is at catching errors."* The compiler
  crashed instead of catching the error. Open for over 5 years.

- **[#1964 — "Incorrect type mismatch when recursing with a wrapped type variable"](https://github.com/elm/compiler/issues/1964)**
  (open since 2019)

  The **generics-over-recursive-functions** class — and Elm, despite
  being a decade old, **still has an open issue in exactly that spot**:

  ```elm
  type Type a
      = TypeCtor (Type (Wrapper a))   -- removing the `Wrapper` around `a` fixes it
  ```

  The type variable `a` gets unified against copies of itself across
  recursive calls, so recursing with a different instantiation than
  the original fails to type-check. The reporter notes this is
  **polymorphic recursion**, which is undecidable in general without
  explicit annotations — a known-hard problem, which is why a
  type-directed generator would struggle to explore it well. Open for
  6+ years.

---

## The framing

Codegen correctness is an unsolved problem even for the most mature,
best-resourced, highest-stakes compilers. Finding and fixing these bugs
is what a healthy compiler project *does* — Gleam being young and
catching them pre-release (or fast post-release) is the signal of
health, not the opposite. Every example above is a *silent*
miscompilation or runtime crash in a compiler that is far older and
more battle-tested than Gleam.

The distinction that matters isn't "does the compiler have codegen
bugs" — every functional-to-JS compiler does. It's whether the project
builds the machinery to find them before users do. That's the work
behind this post.
