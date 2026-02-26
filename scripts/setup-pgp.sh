#!/usr/bin/env bash
# ==========================================================================
# setup-pgp.sh — One-time PGP setup (OMG standard)
#
# Exports public key to static/pgp.txt and generates signed mirrors.txt.
# Run once after initial setup or after PGP key rotation.
#
# Usage: ./scripts/setup-pgp.sh
# ==========================================================================

set -euo pipefail

GPG_KEY="3C3A9612FCDC0242652ECFD3B004471F5EC7A1E7"
ONION="luisbarh3et65nr7kwbft2r24i3dpq5be6goqkfaqutoui2sspqn5sid.onion"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
STATIC_DIR="$PROJECT_ROOT/static"

echo ":: PGP Setup (OMG standard)"

if ! command -v gpg &> /dev/null; then
  echo "ERROR: gpg not found." >&2
  exit 1
fi

# --- Export public key ---
echo ":: Exporting public key to static/pgp.txt..."
gpg --armor --export "$GPG_KEY" > "$STATIC_DIR/pgp.txt"
echo "   static/pgp.txt"

# --- Generate signed mirrors.txt ---
echo ":: Generating signed mirrors.txt..."
MIRRORS_TMP=$(mktemp)
trap 'rm -f "$MIRRORS_TMP"' EXIT

cat > "$MIRRORS_TMP" << EOF
# luisbarcia.com — Official Mirrors
# Signed with PGP key in /pgp.txt
# Any line beginning with http:// or https:// is an official mirror.
https://luisbarcia.com
http://${ONION}
EOF

gpg --local-user "$GPG_KEY" --clearsign --output "$STATIC_DIR/mirrors.txt" "$MIRRORS_TMP"
echo "   static/mirrors.txt"

# --- Fingerprint ---
echo ""
echo ":: Key: $GPG_KEY"
echo ""
echo ":: Files created:"
echo "   static/pgp.txt      — Public key (/pgp.txt)"
echo "   static/mirrors.txt  — Signed mirror list (/mirrors.txt)"
echo ""
echo ":: Next: ./scripts/build.sh --sign"
