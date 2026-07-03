#!/usr/bin/env bash
set -Eeuo pipefail

mode="${1:-guidance}"

show_guidance() {
  cat <<'TEXT'
Caddy Module

Commands:
  ./bootstrap.sh caddy --dry-run
  ./bootstrap.sh caddy --verify

Behavior:
- Verifies Caddy binary and systemd service.
- Does not edit DNS.
- Does not open router ports.
- Does not expose private apps.
TEXT
}

dry_run_caddy() {
  cat <<'TEXT'
Dry-run only.

Official install reference:
https://caddyserver.com/docs/install

This module intentionally does not auto-install yet.
Use verify first, then install deliberately later.
TEXT
}

verify_caddy() {
  echo "Caddy verification"
  echo "=================="

  if command -v caddy >/dev/null 2>&1; then
    echo "PASS Caddy binary found: $(command -v caddy)"
    caddy version || true
  else
    echo "WARN Caddy binary not found"
  fi

  echo
  echo "Systemd:"
  if systemctl list-unit-files caddy.service >/dev/null 2>&1; then
    echo "PASS caddy.service exists"
    systemctl is-active caddy || true
  else
    echo "WARN caddy.service not found"
  fi

  echo
  echo "Ports 80/443:"
  ss -tulpen 2>/dev/null | grep -E ':(80|443)[[:space:]]' || echo "INFO Nothing obvious listening on 80/443"
}

case "$mode" in
  --dry-run) dry_run_caddy ;;
  --verify) verify_caddy ;;
  guidance|"") show_guidance ;;
  *) echo "ERROR Unknown caddy option: $mode"; show_guidance; exit 1 ;;
esac
