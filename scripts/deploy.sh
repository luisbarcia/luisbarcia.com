#!/usr/bin/env bash
# ==========================================================================
# deploy.sh — Deploy luisbarcia.com to VPS via rsync
#
# Usage:
#   ./scripts/deploy.sh              # Deploy public/ to VPS
#   ./scripts/deploy.sh --dry-run    # Preview what would be synced
# ==========================================================================

set -euo pipefail

VPS_IP="5.189.155.226"
VPS_PATH="/opt/stack/site"
ONION="luisbarci6v3d7zshng7ct767wfw24wowy25klo4dk2zvozz5r6lugyd.onion"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PUBLIC_DIR="$PROJECT_ROOT/public"

RSYNC_FLAGS="-avz --delete"

for arg in "$@"; do
  case "$arg" in
    --dry-run) RSYNC_FLAGS="$RSYNC_FLAGS --dry-run" ;;
  esac
done

if [[ ! -d "$PUBLIC_DIR" ]]; then
  echo "ERROR: public/ not found. Run ./scripts/build.sh first." >&2
  exit 1
fi

echo ":: Deploying luisbarcia.com"
echo "   Target: root@${VPS_IP}:${VPS_PATH}/"

rsync $RSYNC_FLAGS "$PUBLIC_DIR/" "root@${VPS_IP}:${VPS_PATH}/"

echo ""
echo ":: Done."
echo "   Clearnet: https://luisbarcia.com"
echo "   Onion:    http://${ONION}"
