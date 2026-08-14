#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: 2026 The Gleam contributors
#
# Provision a bare-metal VPS (Ubuntu/Debian, systemd) for continuous
# Gleam compiler red teaming. Idempotent — safe to re-run.
#
#   curl -fsSL https://raw.githubusercontent.com/daniellionel01/gleam/red-team/redteam/ops/setup.sh | sudo bash
#
# or from a checkout:
#
#   sudo redteam/ops/setup.sh
#
# Environment overrides:
#   REDTEAM_USER   user to run campaigns as        (default: redteam)
#   REPO_URL       fork to clone                   (default: github.com/daniellionel01/gleam)
#   BRANCH         branch to track                 (default: red-team)
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  exec sudo --preserve-env=REDTEAM_USER,REPO_URL,BRANCH bash "$0" "$@"
fi

REDTEAM_USER="${REDTEAM_USER:-redteam}"
REPO_URL="${REPO_URL:-https://github.com/daniellionel01/gleam.git}"
BRANCH="${BRANCH:-red-team}"

echo "==> [1/7] system packages"
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq --no-install-recommends \
  build-essential pkg-config libssl-dev curl ca-certificates git \
  erlang-base erlang-dev

echo "==> [2/7] node.js"
if ! command -v node >/dev/null 2>&1 || [ "$(node --version | sed 's/^v//;s/\..*//')" -lt 18 ]; then
  curl -fsSL https://deb.nodesource.com/setup_22.x | bash - >/dev/null
  apt-get install -y -qq nodejs
fi
node --version

echo "==> [3/7] user: $REDTEAM_USER"
if ! id "$REDTEAM_USER" >/dev/null 2>&1; then
  useradd --create-home --shell /bin/bash "$REDTEAM_USER"
fi
HOME_DIR="$(getent passwd "$REDTEAM_USER" | cut -d: -f6)"

echo "==> [4/7] swap (fuzz builds are memory-hungry on small boxes)"
if [ "$(free -m | awk '/^Mem:/{print $2}')" -lt 3500 ] && ! swapon --show --noheadings | grep -q .; then
  fallocate -l 2G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile >/dev/null
  swapon /swapfile
  grep -q '^/swapfile' /etc/fstab || echo '/swapfile none swap sw 0 0' >> /etc/fstab
  echo "    2G swapfile added"
else
  echo "    not needed"
fi

echo "==> [5/7] rust toolchains + cargo-fuzz"
sudo -u "$REDTEAM_USER" bash <<'EOF'
set -euo pipefail
if ! command -v rustup >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal >/dev/null
fi
. "$HOME/.cargo/env"
rustup toolchain install stable nightly --profile minimal >/dev/null 2>&1
if ! command -v cargo-fuzz >/dev/null 2>&1; then
  cargo +nightly install cargo-fuzz >/dev/null
fi
echo "    $(cargo --version), $(cargo +nightly --version), cargo-fuzz ok"
EOF

echo "==> [6/7] repository ($REPO_URL @ $BRANCH)"
if [ ! -d "$HOME_DIR/gleam/.git" ]; then
  sudo -u "$REDTEAM_USER" git clone --branch "$BRANCH" "$REPO_URL" "$HOME_DIR/gleam"
else
  sudo -u "$REDTEAM_USER" git -C "$HOME_DIR/gleam" fetch origin
  sudo -u "$REDTEAM_USER" git -C "$HOME_DIR/gleam" checkout "$BRANCH"
  sudo -u "$REDTEAM_USER" git -C "$HOME_DIR/gleam" reset --hard "origin/$BRANCH"
fi

echo "==> [7/7] fuzz target build + systemd units"
sudo -u "$REDTEAM_USER" bash -c '. "$HOME/.cargo/env" && cd "$HOME/gleam" && cargo +nightly fuzz build'
REDTEAM_USER="$REDTEAM_USER" HOME_DIR="$HOME_DIR" \
  "$HOME_DIR/gleam/redteam/ops/install-systemd.sh"

echo ""
echo "Setup complete."
echo "  fuzzing:  systemctl status redteam-fuzz    (logs: journalctl -u redteam-fuzz -f)"
echo "  daily:    systemctl list-timers redteam-sync.timer"
echo "  findings: $HOME_DIR/findings/"
