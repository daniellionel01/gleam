<!--
  SPDX-License-Identifier: Apache-2.0
  SPDX-FileCopyrightText: 2026 The Gleam contributors
-->

# Red Team Ops — continuous running on a VPS

Bare-metal/systemd automation for running the red team program 24/7 on a
small VPS. (Docker deliberately skipped for now: one box, and systemd gives
restarts + scheduling with zero moving parts. Revisit if boxes multiply.)

## Prerequisites

- Ubuntu/Debian box with systemd. Comfortable floor: **2 vCPU / 4 GB RAM /
  20 GB disk** (a 2 GB swapfile is auto-added below 3.5 GB RAM).
- Root or sudo access.
- The `red-team` branch pushed to the fork.

## One-command setup

```sh
curl -fsSL https://raw.githubusercontent.com/daniellionel01/gleam/red-team/redteam/ops/setup.sh | sudo bash
```

This: installs build deps + Erlang + Node 22 + Rust (stable & nightly) +
cargo-fuzz; creates a `redteam` user; clones the fork to
`~redteam/gleam`; builds the fuzz targets; installs and starts two
systemd units. Idempotent — re-run to upgrade the box.

Overrides: `REDTEAM_USER`, `REPO_URL`, `BRANCH` env vars.

## What runs

| Unit | What it does |
|---|---|
| `redteam-fuzz.service` | Infinite sprint loop (`fuzz-loop.sh`): 15 min `parse_only`, 60 min `compile_all_targets` (seeded from `redteam/corpus/`), artifact collection after each sprint. `Restart=always`, `Nice=10`, OOM-sacrificable. |
| `redteam-sync.timer` | Daily 04:00 (`sync-job.sh`): reset checkout to latest `origin/red-team`, rebuild fuzz targets, minimize the on-box corpus. |

Sprint lengths: `SHORT_SPRINT` / `LONG_SPRINT` env vars in the unit.

## Day-to-day

```sh
journalctl -u redteam-fuzz -f          # watch the fuzzer
systemctl list-timers redteam-sync.timer
ls ~redteam/findings/inbox/*/          # NEW crash artifacts (deduped by sha256)
cat ~redteam/findings/NEW.log          # chronological "new crash" feed
```

When `NEW.log` has entries: pull the artifact, replay locally
(`cargo +nightly fuzz run <target> <artifact>`), minimize, classify into
`redteam/findings.md`. Corpus persists on-box under `fuzz/corpus/` and is
minimized daily; git sync of corpus is available but off by default
(`CORPUS_GIT_SYNC=1` + a write deploy key in the sync unit).

## Notes & caveats

- `cargo fuzz run` exits non-zero when it finds a crash; the loop treats
  that as a *result*, not a failure, and hands off to
  `process-artifacts.sh`.
- libFuzzer timeouts (`-timeout=`) also produce artifacts. A hanging
  compiler is a finding too — but expect some noise from pathological
  generated inputs; triage accordingly.
- The box needs no secrets for read-only operation. Pushing anything
  (corpus sync) requires a repo deploy key.
- Teardown: `systemctl disable --now redteam-fuzz.service redteam-sync.timer`.
