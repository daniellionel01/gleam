#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: 2026 The Gleam contributors
#
# Collect crash artifacts left by libFuzzer after a sprint: dedupe by
# content hash into the findings inbox and clear the artifact dir.
#
#   process-artifacts.sh <fuzz-target-name>
#
# New artifacts land in $HOME/findings/inbox/<target>/<sha256> and are
# announced in $HOME/findings/NEW.log. Triage (replay, minimize via
# treereduce, classify into redteam/findings.md) is a manual step.
set -uo pipefail

TARGET="${1:?usage: process-artifacts.sh <fuzz-target-name>}"
ROOT="${REDTEAM_ROOT:-$HOME/gleam}"
ART="$ROOT/fuzz/artifacts/$TARGET"
INBOX="$HOME/findings/inbox/$TARGET"

mkdir -p "$INBOX"
[ -d "$ART" ] || exit 0

shopt -s nullglob
new=0
for f in "$ART"/*; do
  hash="$(sha256sum "$f" | awk '{print $1}')"
  if [ ! -e "$INBOX/$hash" ]; then
    cp "$f" "$INBOX/$hash"
    printf '%s %s %s\n' "$(date -u +%FT%TZ)" "$TARGET" "$hash" \
      >> "$HOME/findings/NEW.log"
    new=$((new + 1))
  fi
done
rm -f "$ART"/* 2>/dev/null || true

[ "$new" -gt 0 ] && echo "[process-artifacts] $TARGET: $new NEW crash artifact(s) -> $INBOX"
exit 0
