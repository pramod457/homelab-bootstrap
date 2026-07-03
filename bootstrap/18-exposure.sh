#!/usr/bin/env bash
set -Eeuo pipefail

mode="${1:-verify}"

verify_exposure() {
  echo "Exposure audit"
  echo "=============="

  echo
  echo "Listening sockets:"
  ss -tulpen 2>/dev/null || true

  echo
  echo "UFW status:"
  ufw_output="$(sudo -n ufw status numbered 2>/dev/null || ufw status numbered 2>/dev/null || true)"
  echo "$ufw_output"

  echo
  echo "SSH exposure:"
  if echo "$ufw_output" | grep -Ei '22/tcp|OpenSSH' | grep -Eiq 'Anywhere|0\.0\.0\.0|::/0'; then
    if echo "$ufw_output" | grep -Ei '22/tcp|OpenSSH' | grep -iq 'tailscale0'; then
      echo "PASS SSH appears restricted to tailscale0"
    else
      echo "WARN SSH may be broadly exposed"
    fi
  else
    echo "INFO No broad SSH UFW rule detected"
  fi

  echo
  echo "HTTP/HTTPS exposure:"
  if echo "$ufw_output" | grep -Eiq '80/tcp|443/tcp|Nginx Full|Apache Full|Caddy'; then
    echo "WARN HTTP/HTTPS firewall rule found. Confirm intentionally public."
  else
    echo "PASS No obvious UFW allow rules for public 80/443"
  fi

  echo
  echo "Router/NAT:"
  echo "INFO Local script cannot prove router port-forwarding. Check router manually."
}

case "$mode" in
  --verify|verify|"") verify_exposure ;;
  *) echo "ERROR Unknown exposure option: $mode"; exit 1 ;;
esac
