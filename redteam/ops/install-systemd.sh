#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: 2026 The Gleam contributors
#
# Generate and install the systemd units for continuous red teaming.
# Called by setup.sh (which supplies REDTEAM_USER and HOME_DIR); can be
# re-run standalone as root after changing unit definitions.
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "error: install-systemd.sh must run as root" >&2
  exit 1
fi
U="${REDTEAM_USER:?REDTEAM_USER required}"
H="${HOME_DIR:?HOME_DIR required}"
G="$H/gleam"

cat > /etc/systemd/system/redteam-fuzz.service <<EOF
[Unit]
Description=Gleam compiler red team: continuous fuzzing
After=network-online.target

[Service]
Type=simple
User=$U
Environment=HOME=$H
Environment=PATH=$H/.cargo/bin:/usr/local/bin:/usr/bin:/bin
WorkingDirectory=$G
ExecStart=$G/redteam/ops/fuzz-loop.sh
Restart=always
RestartSec=30
Nice=10
# Fuzzing is best-effort background work: lose the OOM fight gracefully.
OOMScoreAdjust=500

[Install]
WantedBy=multi-user.target
EOF

cat > /etc/systemd/system/redteam-sync.service <<EOF
[Unit]
Description=Gleam compiler red team: daily update, rebuild, corpus maintenance

[Service]
Type=oneshot
User=$U
Environment=HOME=$H
Environment=PATH=$H/.cargo/bin:/usr/local/bin:/usr/bin:/bin
WorkingDirectory=$G
ExecStart=$G/redteam/ops/sync-job.sh
EOF

cat > /etc/systemd/system/redteam-sync.timer <<EOF
[Unit]
Description=Gleam compiler red team: daily sync

[Timer]
OnCalendar=*-*-* 04:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

systemctl daemon-reload
systemctl enable --now redteam-fuzz.service
systemctl enable --now redteam-sync.timer

# Allow the sync job (running as the redteam user) to restart exactly the
# fuzz service after updates — nothing else.
cat > /etc/sudoers.d/redteam-fuzz-restart <<EOF
$U ALL=(root) NOPASSWD: /usr/bin/systemctl restart redteam-fuzz.service
EOF
chmod 440 /etc/sudoers.d/redteam-fuzz-restart

echo "systemd units installed: redteam-fuzz.service, redteam-sync.timer"
