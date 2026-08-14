#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: 2026 The Gleam contributors
#
# The continuous fuzzing loop, run by redteam-fuzz.service. Alternates
# bounded sprints of the fuzz targets and processes any crash artifacts
# after each sprint. Never exits on purpose; systemd restarts it if it
# ever does.
#
# Sprint lengths are env-tunable (seconds):
#   SHORT_SPRINT  parse_only          (default 900)
#   LONG_SPRINT   smith_compile and compile_all_targets (default 3600 each)
set -uo pipefail

ROOT="${REDTEAM_ROOT:-$HOME/gleam}"
cd "$ROOT"

SHORT="${SHORT_SPRINT:-900}"
LONG="${LONG_SPRINT:-3600}"

# libFuzzer grows the FIRST corpus dir it is given; extra dirs are
# read-only seed corpora. The default fuzz/corpus/<target> dir stays the
# growth dir everywhere; curated seeds are copied in or appended after.
mkdir -p fuzz/corpus/smith_compile

echo "[fuzz-loop] starting. root=$ROOT short=${SHORT}s long=${LONG}s"

while true; do
  echo "[fuzz-loop] $(date -u +%FT%TZ) parse_only sprint (${SHORT}s)"
  cargo +nightly fuzz run parse_only -- \
    -max_total_time="$SHORT" -timeout=10 || true
  redteam/ops/process-artifacts.sh parse_only || true

  echo "[fuzz-loop] $(date -u +%FT%TZ) smith_compile sprint (${LONG}s)"
  cargo +nightly fuzz run smith_compile \
    fuzz/corpus/smith_compile redteam/fuzz-seeds/smith_compile -- \
    -max_total_time="$LONG" -timeout=25 || true
  redteam/ops/process-artifacts.sh smith_compile || true

  echo "[fuzz-loop] $(date -u +%FT%TZ) compile_all_targets sprint (${LONG}s)"
  cargo +nightly fuzz run compile_all_targets -- \
    -max_total_time="$LONG" -timeout=25 || true
  redteam/ops/process-artifacts.sh compile_all_targets || true
done
