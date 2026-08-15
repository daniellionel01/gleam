#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: 2026 The Gleam contributors
# Differential runner: compile & run ONE Gleam module (must expose
# `pub fn main`) on the Erlang and JavaScript targets and compare
# observable behaviour (program output + exit status).
#
# Usage:
#   redteam/bin/diff-run.sh path/to/case.gleam        # human-readable report
#   redteam/bin/diff-run.sh --interesting case.gleam  # exit 0 iff divergence found
#
# Notes:
# - `echo` writes to stderr, merged with build progress and warnings. The
#   normaliser strips progress, warning blocks (awk: `warning:`..blank),
#   the per-target echo source-location line, and finally WHITELISTS only
#   value-shaped lines. The whitelist is the robust backstop — Gleam emits
#   many diagnostic prose forms (Hint:, multi-line messages, carets) that
#   are fragile to blacklist; a value-shape whitelist keeps only what the
#   program actually prints. This keeps target-specific warnings (e.g. the
#   F-3 record() hygiene warning, Erlang-only) out of the differential
#   signal — we compare program output, not compiler complaints.
# - The --interesting mode is an "interestingness test" for test-case
#   reducers (e.g. treereduce): exit 0 means "this input is a divergence,
#   keep shrinking it".
set -uo pipefail

MODE="report"
if [ "${1:-}" = "--interesting" ]; then
  MODE="interesting"; shift
fi
INPUT="${1:-}"
if [ -z "$INPUT" ] || [ ! -f "$INPUT" ]; then
  echo "usage: diff-run.sh [--interesting] <case.gleam>" >&2
  exit 2
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

command -v erl  >/dev/null || { echo "error: Erlang (erl) not found" >&2; exit 2; }
command -v node >/dev/null || { echo "error: Node.js (node) not found" >&2; exit 2; }

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
mkdir -p "$WORK/src"
cp "$INPUT" "$WORK/src/main.gleam"
printf 'name = "redteam_case"\n' > "$WORK/gleam.toml"

GLEAM_BIN="${GLEAM_BIN:-}"
if [ -n "$GLEAM_BIN" ]; then
  GLEAM=("$GLEAM_BIN")
else
  GLEAM=(cargo run -q -p gleam --manifest-path "$ROOT/Cargo.toml" --)
fi

run_target() {
  # $1 = target, everything else = extra args for `gleam run`
  # `echo` writes to stderr, merged with build progress + warnings; the
  # normaliser strips those. stdout is currently unused by `echo`.
  local target="$1"; shift
  (cd "$WORK" && "${GLEAM[@]}" run --target "$target" --module main "$@") \
    >"$WORK/$target.raw" 2>&1
  return $?
}

# Normalise: strip ANSI, warning blocks (awk: warning:..blank), the echo
# source-location line, then WHITELIST value-shaped lines only.
# Value shapes: Int, String, Bool, List, Tuple, BitArray, constructor.
normalise() {
  sed -E $'s/\\x1b\\[[0-9;]*m//g' "$1" \
    | awk '
      /^warning:/ { in_warn=1; next }
      in_warn && /^$/ { in_warn=0; next }
      in_warn { next }
      { print }
    ' \
    | grep -vE 'main\.gleam:[0-9]+' \
    | grep -E '^-?[0-9]+$|^".*"*$|^(True|False)$|^\[.*\]$|^#\(.*\)$|^<<.*>>$|^[A-Z][A-Za-z0-9_]*(\(.*\))?$' \
    | sed -E 's/[[:space:]]+$//'
}

ERLANG_STATUS=0
JS_STATUS=0
run_target erlang || ERLANG_STATUS=$?
run_target javascript --runtime nodejs || JS_STATUS=$?

normalise "$WORK/erlang.raw" > "$WORK/erlang.out"
normalise "$WORK/javascript.raw" > "$WORK/javascript.out"

if [ "$ERLANG_STATUS" -eq 0 ] && [ "$JS_STATUS" -eq 0 ] && cmp -s "$WORK/erlang.out" "$WORK/javascript.out"; then
  VERDICT="MATCH"
else
  VERDICT="MISMATCH"
fi

if [ "$MODE" = "interesting" ]; then
  [ "$VERDICT" = "MISMATCH" ]
  exit $?
fi

echo "=== redteam diff-run ==="
echo "input:           $INPUT"
echo "erlang status:   $ERLANG_STATUS"
echo "nodejs status:   $JS_STATUS"
echo "verdict:         $VERDICT"
echo "--- erlang output (normalised) ---"
cat "$WORK/erlang.out"
echo "--- nodejs output (normalised) ---"
cat "$WORK/javascript.out"
if [ "$VERDICT" = "MISMATCH" ]; then
  echo "--- raw diff (erlang | nodejs) ---"
  diff "$WORK/erlang.raw" "$WORK/javascript.raw" | head -40
fi
[ "$VERDICT" = "MATCH" ]
