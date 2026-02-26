#!/usr/bin/env bash
# ==========================================================================
# build.sh — Build luisbarcia.com with optional PGP signing
#
# Usage:
#   ./scripts/build.sh              # Build only
#   ./scripts/build.sh --sign       # Build + sign with PGP
#   ./scripts/build.sh --clean      # Clean + build
# ==========================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PUBLIC_DIR="$PROJECT_ROOT/public"
STATIC_DIR="$PROJECT_ROOT/static"
GPG_KEY="3C3A9612FCDC0242652ECFD3B004471F5EC7A1E7"
SIGN=false
CLEAN=false

for arg in "$@"; do
  case "$arg" in
    --sign) SIGN=true ;;
    --clean) CLEAN=true ;;
    *) echo "Unknown arg: $arg"; exit 1 ;;
  esac
done

echo ":: luisbarcia.com — Build"

if [[ "$CLEAN" == true ]] || [[ ! -d "$PUBLIC_DIR" ]]; then
  echo ":: Cleaning public/..."
  rm -rf "$PUBLIC_DIR"
fi

# --- Build ---
echo ":: Building with Hugo..."
cd "$PROJECT_ROOT"
hugo --gc --minify

# --- Checksums ---
echo ":: Generating SHA-256 checksums..."
BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

cd "$PUBLIC_DIR"
find . -type f \( -name '*.html' -o -name '*.xml' -o -name '*.json' -o -name '*.css' -o -name '*.js' \) \
  | sort \
  | xargs shasum -a 256 \
  > SHA256SUMS

ROOT_HASH=$(shasum -a 256 SHA256SUMS | awk '{print $1}')

cat > build-info.txt << EOF
luisbarcia.com — Build Verification
Date:       $BUILD_DATE
Root hash:  $ROOT_HASH
Hugo:       $(hugo version 2>/dev/null | head -1)
Pages:      $(find . -name '*.html' | wc -l | tr -d ' ')

The root hash is the SHA-256 of SHA256SUMS.

Verify:
  curl -sO https://luisbarcia.com/build-info.txt
  curl -sO https://luisbarcia.com/build-info.txt.asc
  curl -sO https://luisbarcia.com/SHA256SUMS
  gpg --verify build-info.txt.asc build-info.txt
  shasum -a 256 -c SHA256SUMS
EOF

cd "$PROJECT_ROOT"
echo "   Date:      $BUILD_DATE"
echo "   Root hash: $ROOT_HASH"
echo "   Pages:     $(find "$PUBLIC_DIR" -name '*.html' | wc -l | tr -d ' ')"

# --- PGP Sign ---
if [[ "$SIGN" == true ]]; then
  echo ":: Signing with PGP..."

  gpg --local-user "$GPG_KEY" --armor --detach-sign \
    --output "$PUBLIC_DIR/build-info.txt.asc" \
    "$PUBLIC_DIR/build-info.txt"
  echo "   build-info.txt.asc"

  gpg --local-user "$GPG_KEY" --armor --detach-sign \
    --output "$PUBLIC_DIR/SHA256SUMS.asc" \
    "$PUBLIC_DIR/SHA256SUMS"
  echo "   SHA256SUMS.asc"

  if [[ -f "$STATIC_DIR/pgp.txt" ]]; then
    cp "$STATIC_DIR/pgp.txt" "$PUBLIC_DIR/pgp.txt"
    echo "   pgp.txt"
  fi
else
  echo ":: Skipping PGP signing (use --sign to enable)"
fi

echo ":: Build complete."
