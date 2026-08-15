#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: 2026 The Gleam contributors
#
# Version-scope triage: does a given finding reproduce on a RELEASED
# compiler, or is it main-only? Answers the question that was missed
# manually this session (the F-7..F-11 snippets were assumed to crash
# the user's installed 1.18.1 — they didn't).
#
#   version-check.sh [--tag v1.x.y] [--target erlang|javascript] <fixture.gleam>
#
# Defaults to the latest non-rc tag reachable from HEAD.
#
# ISOLATION GUARANTEES (no ripple into the fuzzing loop):
#   - NEVER invoked by fuzz-loop.sh, sync-job.sh, or smith-campaign.sh.
#     Manual triage only.
#   - Builds the release compiler in a throwaway `git worktree` (its own
#     target/ dir); the main checkout's branch and build artifacts are
#     untouched. The worktree is removed afterwards.
#   - Caches the release binary at redteam/findings/.bin-cache/<tag>/gleam
#     so subsequent checks are instant.
#   - Runs the fixture through diff-run.sh in a temp project (diff-run's
#     own WORK dir, removed on exit). No writes to the repo tree or corpus.
#
# Output: for each target, whether the release compiler panics / compiles /
# runs, then a one-line scope verdict:
#   REPRODUCES ON <tag>  → long-standing (present in the release)
#   ABSENT ON <tag>      → main-only regression (not in the release)
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TAG=""
TARGET=""
FIXTURE=""

while [ $# -gt 0 ]; do
  case "$1" in
    --tag)    TAG="$2"; shift 2 ;;
    --target) TARGET="$2"; shift 2 ;;
    --) shift; FIXTURE="${1:-}"; break ;;
    *)  FIXTURE="$1"; shift ;;
  esac
done

if [ -z "$FIXTURE" ] || [ ! -f "$FIXTURE" ]; then
  echo "usage: version-check.sh [--tag v1.x.y] [--target erlang|javascript] <fixture.gleam>" >&2
  exit 2
fi

# Resolve the nearest release tag if not given.
if [ -z "$TAG" ]; then
  TAG="$(cd "$ROOT" && git tag --sort=-v:refname \
    | grep -vE -- '-rc' | head -1)" || true
  if [ -z "$TAG" ]; then
    echo "error: no release tag reachable from HEAD; pass --tag explicitly" >&2
    exit 2
  fi
fi

CACHE="$ROOT/redteam/findings/.bin-cache/$TAG/gleam"
mkdir -p "$(dirname "$CACHE")"

# --- build the release compiler in a throwaway worktree (cached) ----------
if [ ! -x "$CACHE" ]; then
  echo "[version-check] building $TAG in a throwaway worktree (cached after first run)..."
  WT="$(mktemp -d -t gleam-XXXX)"
  trap 'rm -rf "$WT"' EXIT
  if ! (cd "$ROOT" && git worktree add --detach "$WT" "$TAG" >/dev/null 2>&1); then
    echo "error: could not add worktree for $TAG" >&2
    git -C "$ROOT" worktree prune 2>/dev/null || true
    exit 2
  fi
  if ! (cd "$WT" && cargo build --release -p gleam >/dev/null 2>&1); then
    echo "error: release build of $TAG failed" >&2
    git -C "$ROOT" worktree remove --force "$WT" 2>/dev/null || true
    exit 2
  fi
  cp "$WT/target/release/gleam" "$CACHE"
  git -C "$ROOT" worktree remove --force "$WT" 2>/dev/null || true
  echo "[version-check] cached $TAG binary at $CACHE"
fi

# --- run the fixture through the release binary --------------------------
# Two paths, picked by whether the fixture is runnable:
#   * has `pub fn main` -> use diff-run.sh (handles panics-in-run AND
#     silent divergences; reuses existing, tested run/diff logic).
#   * no main (e.g. a parse/const crash like F-5) -> build-only panic
#     check on both targets. A crash finding doesn't need to run.
# diff-run.sh and the build path each isolate the run in a temp project.
HAS_MAIN="$(grep -cE '^[[:space:]]*pub fn main' "$FIXTURE" || true)"
RAW_OUT="$(mktemp)"
trap 'rm -rf "$RAW_OUT"' EXIT

if [ "$HAS_MAIN" -gt 0 ]; then
  echo "[version-check] running $FIXTURE against $TAG (diff-run, both targets)..."
  GLEAM_BIN="$CACHE" "$ROOT/redteam/bin/diff-run.sh" "$FIXTURE" >"$RAW_OUT" 2>&1
  VERDICT="$(grep -E '^verdict:' "$RAW_OUT" | awk '{print $2}')"
  PANICS="$(grep -c 'Fatal compiler bug' "$RAW_OUT" || true)"
  echo "verdict:   ${VERDICT:-unknown} (MATCH = targets agree, MISMATCH = they differ)"
  echo "panics:    $PANICS"
  REPRODUCES=0
  [ "$PANICS" -gt 0 ] && REPRODUCES=1
  [ "$VERDICT" = "MISMATCH" ] && REPRODUCES=1
else
  echo "[version-check] building $FIXTURE against $TAG (no main; panic check only)..."
  WORK2="$(mktemp -d)"; trap 'rm -rf "$RAW_OUT" "$WORK2"' EXIT
  mkdir -p "$WORK2/src"; cp "$FIXTURE" "$WORK2/src/main.gleam"
  printf 'name = "vcheck"\n' > "$WORK2/gleam.toml"
  PANICS=0
  for t in erlang javascript; do
    out="$(cd "$WORK2" && "$CACHE" build --target "$t" 2>&1)" || true
    p="$(printf '%s' "$out" | grep -c 'Fatal compiler bug' || true)"
    echo "$t: $([ "$p" -gt 0 ] && echo PANIC || echo no-panic)"
    PANICS=$((PANICS + p))
  done
  VERDICT="n/a (no main; build-only)"
  REPRODUCES=0; [ "$PANICS" -gt 0 ] && REPRODUCES=1
fi

echo
if [ "$REPRODUCES" -eq 1 ]; then
  echo "SCOPE: REPRODUCES ON $TAG  → long-standing (present in the release)"
else
  echo "SCOPE: ABSENT ON $TAG      → main-only regression (not in the release)"
fi
exit 0
