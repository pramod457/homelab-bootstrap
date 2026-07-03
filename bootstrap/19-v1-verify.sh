#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mode="${1:-guidance}"

show_guidance() {
  cat <<'TEXT'
V1 Verification

Commands:
  ./bootstrap.sh v1 --verify

Runs all safe V1 verification modules.
TEXT
}

run_v1_verify() {
  echo "homelab-bootstrap V1 verification"
  echo "================================="

  sudo -v || true

  "$ROOT_DIR/bootstrap.sh" doctor --sudo || "$ROOT_DIR/bootstrap.sh" doctor
  "$ROOT_DIR/bootstrap.sh" docker --verify
  "$ROOT_DIR/bootstrap.sh" nvidia --verify
  "$ROOT_DIR/bootstrap.sh" tailscale --verify
  "$ROOT_DIR/bootstrap.sh" azure-arc --verify
  "$ROOT_DIR/bootstrap.sh" azure-monitor --verify
  "$ROOT_DIR/bootstrap.sh" caddy --verify
  "$ROOT_DIR/bootstrap.sh" cloudflare-tunnel --verify
  "$ROOT_DIR/bootstrap.sh" exposure --verify

  echo
  echo "V1 verification complete."
}

case "$mode" in
  --verify) run_v1_verify ;;
  guidance|"") show_guidance ;;
  *) echo "ERROR Unknown v1 option: $mode"; show_guidance; exit 1 ;;
esac
