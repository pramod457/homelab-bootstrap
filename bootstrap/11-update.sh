#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/lib/logger.sh"

mode="${1:-guidance}"
REPORT_DIR="$HOME/.local/share/homelab-bootstrap/reports"
REPORT_FILE="$REPORT_DIR/update-$(date +%Y%m%d-%H%M%S).log"

show_guidance() {
  cat <<'TEXT'
Update Module

Commands:
  ./bootstrap.sh update --dry-run
  ./bootstrap.sh update --apply

Behavior:
- Dry-run updates package metadata and simulates normal upgrades.
- Apply runs normal Ubuntu package upgrades.
- It uses apt-get for script-safe package operations.
- It does not run dist-upgrade/full-upgrade.
- It does not autoremove packages automatically.
- It reports kept-back packages when apt-get exposes them.
- It reports if reboot is required.

Recommended:
- Run dry-run first.
- Run apply only when you have time to reboot if needed.
TEXT
}

print_reboot_status() {
  echo
  echo "Reboot status:"
  if [ -f /var/run/reboot-required ]; then
    echo "Reboot required"
    cat /var/run/reboot-required.pkgs 2>/dev/null || true
  else
    echo "No reboot required currently"
  fi
}

print_kept_back() {
  local sim_file="$1"

  echo
  echo "Kept-back package status:"

  if grep -qi "kept back" "$sim_file"; then
    grep -i -A20 "kept back" "$sim_file" || true
  else
    echo "No kept-back packages reported by apt-get simulation."
  fi
}

dry_run_update() {
  mkdir -p "$REPORT_DIR"
  local sim_file="$REPORT_DIR/update-simulation-$(date +%Y%m%d-%H%M%S).log"

  {
    echo "Update dry-run report"
    echo "Date: $(date)"
    echo

    info "Updating package metadata"
    sudo apt-get update

    echo
    echo "Upgradeable package summary:"
    sudo apt-get -s upgrade 2>/dev/null | sed -n 's/^Inst /- /p' || true

    echo
    echo "Simulated normal upgrade:"
    sudo apt-get -s upgrade 2>&1 | tee "$sim_file" || true

    print_kept_back "$sim_file"
    print_reboot_status
  } | tee "$REPORT_FILE"

  info "Dry-run report saved to $REPORT_FILE"
}

apply_update() {
  mkdir -p "$REPORT_DIR"
  local post_sim_file="$REPORT_DIR/update-post-apply-simulation-$(date +%Y%m%d-%H%M%S).log"

  echo "This will apply Ubuntu package updates."
  echo "It will NOT run dist-upgrade/full-upgrade."
  echo "It will NOT autoremove packages."
  echo
  read -r -p "Type UPDATE to continue: " confirm

  if [ "$confirm" != "UPDATE" ]; then
    echo "Cancelled."
    exit 0
  fi

  {
    echo "Update apply report"
    echo "Date: $(date)"
    echo

    info "Updating package metadata"
    sudo apt-get update

    info "Applying normal package upgrades"
    sudo apt-get upgrade -y

    echo
    echo "Post-apply normal upgrade simulation:"
    sudo apt-get -s upgrade 2>&1 | tee "$post_sim_file" || true

    print_kept_back "$post_sim_file"
    print_reboot_status
  } | tee "$REPORT_FILE"

  info "Update report saved to $REPORT_FILE"
}

case "$mode" in
  --dry-run)
    dry_run_update
    ;;
  --apply)
    apply_update
    ;;
  guidance|"")
    show_guidance
    ;;
  *)
    error "Unknown update option: $mode"
    show_guidance
    exit 1
    ;;
esac
