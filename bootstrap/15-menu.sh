#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
ROOT_DIR="$(cd "$(dirname "$SCRIPT_PATH")/.." && pwd)"
BOOTSTRAP="$ROOT_DIR/bootstrap.sh"

pause() {
  echo
  read -r -p "Press Enter to continue..." _
}

run_cmd() {
  echo
  echo "==> $*"
  "$@"
  pause
}

run_v1_checks() {
  sudo -v || true
  "$BOOTSTRAP" v1 --verify
  pause
}

while true; do
  clear || true
  cat <<'MENU'
homelab-bootstrap menu

Core:
1. Doctor / health check
2. Run full V1 verification
3. Show help

Security:
4. Security dry-run
5. Security apply
6. Exposure audit

Updates:
7. Update dry-run
8. Update apply

Docker / GPU:
9. Docker verify
10. Docker apply/install
11. NVIDIA verify
12. NVIDIA container GPU test

Remote / Hybrid:
13. Tailscale verify
14. Tailscale netcheck
15. Azure Arc verify
16. Azure Monitor verify

Web / Tunnel:
17. Caddy guidance
18. Caddy dry-run
19. Caddy verify
20. Cloudflare Tunnel guidance
21. Cloudflare Tunnel dry-run
22. Cloudflare Tunnel verify

0. Exit
MENU

  read -r -p "Select: " choice

  case "$choice" in
    1) run_cmd "$BOOTSTRAP" doctor --sudo ;;
    2) run_v1_checks ;;
    3) run_cmd "$BOOTSTRAP" help ;;
    4) run_cmd "$BOOTSTRAP" security --dry-run ;;
    5) run_cmd "$BOOTSTRAP" security --apply ;;
    6) run_cmd "$BOOTSTRAP" exposure --verify ;;
    7) run_cmd "$BOOTSTRAP" update --dry-run ;;
    8) run_cmd "$BOOTSTRAP" update --apply ;;
    9) run_cmd "$BOOTSTRAP" docker --verify ;;
    10) run_cmd "$BOOTSTRAP" docker --apply ;;
    11) run_cmd "$BOOTSTRAP" nvidia --verify ;;
    12) run_cmd "$BOOTSTRAP" nvidia --container-test ;;
    13) run_cmd "$BOOTSTRAP" tailscale --verify ;;
    14) run_cmd "$BOOTSTRAP" tailscale --netcheck ;;
    15) run_cmd "$BOOTSTRAP" azure-arc --verify ;;
    16) run_cmd "$BOOTSTRAP" azure-monitor --verify ;;
    17) run_cmd "$BOOTSTRAP" caddy ;;
    18) run_cmd "$BOOTSTRAP" caddy --dry-run ;;
    19) run_cmd "$BOOTSTRAP" caddy --verify ;;
    20) run_cmd "$BOOTSTRAP" cloudflare-tunnel ;;
    21) run_cmd "$BOOTSTRAP" cloudflare-tunnel --dry-run ;;
    22) run_cmd "$BOOTSTRAP" cloudflare-tunnel --verify ;;
    0) exit 0 ;;
    *) echo "Invalid choice"; sleep 1 ;;
  esac
done
