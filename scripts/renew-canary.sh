#!/usr/bin/env bash
# ==========================================================================
# renew-canary.sh — Warrant Canary quarterly renewal
#
# Fetches the latest Bitcoin block, generates a new canary statement,
# signs it with GPG, and updates content/canary.md.
#
# GPG will prompt for passphrase — this is intentional.
# A canary that renews without human presence is meaningless.
#
# Usage:
#   ./scripts/renew-canary.sh
#   ./scripts/renew-canary.sh --no-commit   # skip git commit
# ==========================================================================

set -euo pipefail

# --- Config ---
GPG_KEY="3C3A9612FCDC0242652ECFD3B004471F5EC7A1E7"
SITE_DOMAIN="luisbarcia.com"
VALIDITY_MONTHS=3
MEMPOOL_API="https://mempool.space/api"

# --- Resolve project root ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CANARY_FILE="$PROJECT_ROOT/content/canary.md"

# --- Parse args ---
NO_COMMIT=false
for arg in "$@"; do
  case "$arg" in
    --no-commit) NO_COMMIT=true ;;
  esac
done

# --- Dates ---
TODAY=$(date +%Y-%m-%d)
if date -v +1d > /dev/null 2>&1; then
  # macOS date
  EXPIRES=$(date -v +"${VALIDITY_MONTHS}m" +%Y-%m-%d)
else
  # GNU date
  EXPIRES=$(date -d "+${VALIDITY_MONTHS} months" +%Y-%m-%d)
fi

# --- Fetch Bitcoin block ---
echo ":: Fetching latest Bitcoin block..."
BTC_HEIGHT=$(curl -sf "${MEMPOOL_API}/blocks/tip/height")
BTC_HASH=$(curl -sf "${MEMPOOL_API}/blocks/tip/hash")

if [[ -z "$BTC_HEIGHT" || -z "$BTC_HASH" ]]; then
  echo "ERROR: Could not fetch Bitcoin block data from mempool.space" >&2
  exit 1
fi

echo "   Block #${BTC_HEIGHT}: ${BTC_HASH}"

# --- Generate canary text ---
CANARY_TXT=$(mktemp)
trap 'rm -f "$CANARY_TXT" "${CANARY_TXT}.asc"' EXIT

cat > "$CANARY_TXT" << EOF
Canary statement — ${SITE_DOMAIN}
Date: ${TODAY}
Expires: ${EXPIRES}
Bitcoin block: #${BTC_HEIGHT}
Block hash: ${BTC_HASH}

The operator of this site has not received any:
- Warrants
- Subpoenas
- National Security Letters
- Gag orders
- Court orders requiring disclosure of user data
- Requests to install backdoors or surveillance capabilities

from any government agency or law enforcement body.

This canary is updated quarterly. If it is not renewed by the
expiration date, the absence of this statement should be
interpreted accordingly.
EOF

# --- Sign with GPG ---
echo ":: Signing canary with GPG key ${GPG_KEY}..."
gpg --local-user "$GPG_KEY" --clearsign "$CANARY_TXT"

# --- Verify signature ---
echo ":: Verifying signature..."
gpg --verify "${CANARY_TXT}.asc" 2>&1 | grep -q "Good signature" || {
  echo "ERROR: Signature verification failed" >&2
  exit 1
}

# --- Read signed content ---
SIGNED_CONTENT=$(cat "${CANARY_TXT}.asc")

# --- Write canary.md ---
echo ":: Writing ${CANARY_FILE}..."
cat > "$CANARY_FILE" << CANARYMD
---
title: "Warrant Canary"
description: "Transparency report — no warrants, gag orders, or national security letters received."
date: ${TODAY}
layout: canary
expires: ${EXPIRES}
bitcoin_block: ${BTC_HEIGHT}
bitcoin_hash: "${BTC_HASH}"
---

\`\`\`
${SIGNED_CONTENT}
\`\`\`
CANARYMD

echo ":: Canary updated successfully."
echo ""
echo "   Date:    ${TODAY}"
echo "   Expires: ${EXPIRES}"
echo "   Block:   #${BTC_HEIGHT}"
echo ""

# --- Git commit ---
if [[ "$NO_COMMIT" == false ]]; then
  echo ":: Committing..."
  cd "$PROJECT_ROOT"
  git add content/canary.md
  git commit -m "$(cat <<'EOF'
docs: renew warrant canary

Quarterly canary renewal with fresh Bitcoin block proof
and PGP signature.
EOF
  )"
  echo ":: Committed. Don't forget to push."
else
  echo ":: Skipped git commit (--no-commit)."
fi
