#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: 2026 The Gleam contributors
#
# Differential execution campaign: generate gleam-smith programs and run
# each on both targets via diff-run.sh. Divergences (or compiler crashes)
# are kept under redteam/findings/smith/ for triage.
#
#   smith-campaign.sh [start-seed] [count]
#
# Requires: erl, node, and the workspace built (script builds gleam-smith
# and the gleam CLI itself).
set -uo pipefail

START="${1:-0}"
COUNT="${2:-50}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
OUT="$ROOT/redteam/findings/smith"
mkdir -p "$OUT"

command -v erl  >/dev/null || { echo "error: Erlang (erl) not found" >&2; exit 2; }
command -v node >/dev/null || { echo "error: Node.js (node) not found" >&2; exit 2; }

echo "[smith-campaign] building generator + compiler..."
cargo build -q --manifest-path "$ROOT/Cargo.toml" -p gleam-smith -p gleam
SMITH="$ROOT/target/debug/gleam-smith"

echo "[smith-campaign] seeds $START..$((START + COUNT - 1)) -> $OUT"
found=0
ran=0
for seed in $(seq "$START" $((START + COUNT - 1))); do
  src="$OUT/.current.gleam"
  "$SMITH" gen "$seed" > "$src"
  if "$ROOT/redteam/bin/diff-run.sh" --interesting "$src"; then
    dest="$OUT/seed_$seed.gleam"
    mv "$src" "$dest"
    echo "[smith-campaign] DIVERGENCE seed $seed -> $dest"
    found=$((found + 1))
  fi
  ran=$((ran + 1))
  [ $((ran % 10)) -eq 0 ] && echo "[smith-campaign] $ran/$COUNT run, $found divergences"
done
rm -f "$OUT/.current.gleam"
echo "[smith-campaign] done: $ran programs, $found divergence(s) kept in $OUT"
[ "$found" -eq 0 ]
