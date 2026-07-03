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
  sudo -v
  "$BOOTSTRAP" doctor --sudo
  "$BOOTSTRAP" docker --verify
  "$BOOTSTRAP" nvidia --verify
  "$BOOTSTRAP" tailscale --verify
  "$BOOTSTRAP" azure-arc --verify
  "$BOOTSTRAP" azure-monitor --verify
  pause
}

while true; do
  clear || true
  cat <<'MENU'
homelab-bootstrap menu

1. Doctor / health check
2. Run all V1 verification checks
3. Security dry-run
4. Security apply
5. Update dry-run
6. Update apply
7. Docker verify
8. Docker apply/install
9. NVIDIA verify
10. NVIDIA container GPU test
11. Tailscale verify
12. Tailscale netcheck
13. Azure Arc verify
14. Azure Monitor verify
15. Show help
0. Exit
MENU

  read -r -p "Select: " choice

  case "$choice" in
    1) run_cmd "$BOOTSTRAP" doctor --sudo ;;
    2) run_v1_checks ;;
    3) run_cmd "$BOOTSTRAP" security --dry-run ;;
    4) run_cmd "$BOOTSTRAP" security --apply ;;
    5) run_cmd "$BOOTSTRAP" update --dry-run ;;
    6) run_cmd "$BOOTSTRAP" update --apply ;;
    7) run_cmd "$BOOTSTRAP" docker --verify ;;
    8) run_cmd "$BOOTSTRAP" docker --apply ;;
    9) run_cmd "$BOOTSTRAP" nvidia --verify ;;
    10) run_cmd "$BOOTSTRAP" nvidia --container-test ;;
    11) run_cmd "$BOOTSTRAP" tailscale --verify ;;
    12) run_cmd "$BOOTSTRAP" tailscale --netcheck ;;
    13) run_cmd "$BOOTSTRAP" azure-arc --verify ;;
    14) run_cmd "$BOOTSTRAP" azure-monitor --verify ;;
    15) run_cmd "$BOOTSTRAP" help ;;
    0) exit 0 ;;
    *) echo "Invalid choice"; sleep 1 ;;
  esac
done
