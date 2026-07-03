#!/usr/bin/env bash
set -Eeuo pipefail

mode="${1:-guidance}"

show_guidance() {
  cat <<'TEXT'
Cloudflare Tunnel Module

Commands:
  ./bootstrap.sh cloudflare-tunnel --dry-run
  ./bootstrap.sh cloudflare-tunnel --verify

Behavior:
- Verifies cloudflared binary and service presence.
- Does not create tunnels automatically.
- Does not change DNS.
- Does not store Cloudflare credentials.
TEXT
}

dry_run_cloudflared() {
  cat <<'TEXT'
Dry-run only.

Official install reference:
https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/downloads/

This module intentionally does not auto-create tunnels.
Use Cloudflare dashboard/Zero Trust deliberately later.
TEXT
}

verify_cloudflared() {
  echo "Cloudflare Tunnel verification"
  echo "=============================="

  if command -v cloudflared >/dev/null 2>&1; then
    echo "PASS cloudflared binary found: $(command -v cloudflared)"
    cloudflared --version || true
  else
    echo "WARN cloudflared binary not found"
  fi

  echo
  echo "Systemd:"
  systemctl list-units --type=service --all 2>/dev/null | grep -i cloudflared || echo "INFO No cloudflared service found"

  echo
  echo "Safety:"
  echo "INFO This verifier does not print tunnel credentials."
}

case "$mode" in
  --dry-run) dry_run_cloudflared ;;
  --verify) verify_cloudflared ;;
  guidance|"") show_guidance ;;
  *) echo "ERROR Unknown cloudflare-tunnel option: $mode"; show_guidance; exit 1 ;;
esac
