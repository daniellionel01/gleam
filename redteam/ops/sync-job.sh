#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: 2026 The Gleam contributors
#
# Daily maintenance, run by redteam-sync.timer:
#   1. update the checkout to the latest red-team branch
#   2. rebuild the fuzz targets (so the fuzzer tests the latest harness)
#   3. minimize the on-box fuzzing corpus (keeps it lean; corpus persists
#      on disk — it is the accumulated coverage intelligence)
#
# Corpus git sync is OFF by default (corpora get large). Enable by
# setting CORPUS_GIT_SYNC=1 in the unit's Environment; requires a
# write-capable deploy key for the repo.
set -uo pipefail

ROOT="${REDTEAM_ROOT:-$HOME/gleam}"
cd "$ROOT"

echo "[sync] $(date -u +%FT%TZ) updating checkout"
git fetch origin
git checkout red-team
git reset --hard origin/red-team

echo "[sync] rebuilding fuzz targets"
if ! cargo +nightly fuzz build; then
  echo "[sync] BUILD FAILED — leaving fuzz loop on previous build"
  exit 1
fi

echo "[sync] refreshing seed corpus"
mkdir -p fuzz/corpus/compile_all_targets
cp redteam/corpus/*.gleam fuzz/corpus/compile_all_targets/

echo "[sync] minimizing corpora"
cargo +nightly fuzz cmin parse_only || true
cargo +nightly fuzz cmin compile_all_targets || true

if [ "${CORPUS_GIT_SYNC:-0}" = "1" ]; then
  echo "[sync] committing corpus"
  git add fuzz/corpus || true
  if ! git diff --cached --quiet; then
    git -c user.name=redteam-bot -c user.email=redteam-bot@localhost \
      commit -m "corpus: minimize and merge $(date -u +%F)"
    git fetch origin
    git rebase origin/red-team || git rebase --abort
    git push origin red-team || echo "[sync] push failed (deploy key?)"
  else
    echo "[sync] corpus unchanged"
  fi
fi

echo "[sync] done"

# Script/harness changes only take effect in the fuzz loop after a restart.
# The sudoers rule installed by install-systemd.sh permits exactly this.
sudo -n systemctl restart redteam-fuzz.service 2>/dev/null \
  || echo "[sync] could not restart redteam-fuzz (needs root or the sudoers rule)"
