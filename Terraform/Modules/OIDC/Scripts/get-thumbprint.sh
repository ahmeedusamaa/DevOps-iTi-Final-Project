#!/usr/bin/env bash
set -e

OIDC_URL=$1
OIDC_HOST=$(echo "$OIDC_URL" | sed -E 's|^https?://||' | cut -d'/' -f1)

THUMBPRINT=$(openssl s_client -connect "${OIDC_HOST}:443" -servername "${OIDC_HOST}" </dev/null 2>/dev/null \
  | openssl x509 -fingerprint -noout -sha1 \
  | cut -d'=' -f2 | tr -d ':')

if [ -n "$THUMBPRINT" ]; then
  echo "{\"thumbprint\": \"${THUMBPRINT}\"}"
else
  echo '{"error": "Failed to get thumbprint"}'
  exit 1
fi
