#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: 2026 The Gleam contributors
#
# The continuous fuzzing loop, run by redteam-fuzz.service. Alternates
# bounded sprints of the two fuzz targets and processes any crash
# artifacts after each sprint. Never exits on purpose; systemd restarts
# it if it ever does.
#
# Sprint lengths are env-tunable (seconds):
#   SHORT_SPRINT  parse_only          (default 900)
#   LONG_SPRINT   compile_all_targets (default 3600)
set -uo pipefail

ROOT="${REDTEAM_ROOT:-$HOME/gleam}"
cd "$ROOT"

SHORT="${SHORT_SPRINT:-900}"
LONG="${LONG_SPRINT:-3600}"

echo "[fuzz-loop] starting. root=$ROOT short=${SHORT}s long=${LONG}s"

while true; do
  echo "[fuzz-loop] $(date -u +%FT%TZ) parse_only sprint (${SHORT}s)"
  cargo +nightly fuzz run parse_only -- \
    -max_total_time="$SHORT" -timeout=10 || true
  redteam/ops/process-artifacts.sh parse_only || true

  echo "[fuzz-loop] $(date -u +%FT%TZ) compile_all_targets sprint (${LONG}s)"
  # NB: no explicit corpus dir — libFuzzer grows the FIRST corpus dir it is
  # given, and we want that to be the default fuzz/corpus/<target> dir, not
  # the curated seeds. Seeds are copied into the default dir by setup.sh and
  # sync-job.sh instead.
  cargo +nightly fuzz run compile_all_targets -- \
    -max_total_time="$LONG" -timeout=25 || true
  redteam/ops/process-artifacts.sh compile_all_targets || true
done
