#!/usr/bin/env bash
# Creates parla_server/config/passwords.yaml with random secrets for the
# development and test run modes. The file is git-ignored; never commit it.
# Staging and production secrets come from the deployment environment
# (SERVERPOD_PASSWORD_<key> variables), never from this file.
set -euo pipefail

target="$(dirname "$0")/../parla_server/config/passwords.yaml"
if [[ -e "$target" ]]; then
  echo "$target already exists; leaving it unchanged." >&2
  exit 0
fi

secret() { openssl rand -hex 24; }
kek() { openssl rand -base64 32; }

cat > "$target" <<YAML
development:
  database: '$(secret)'
  healthKek: '$(kek)'
  serviceSecret: '$(secret)'
  emailSecretHashPepper: '$(secret)'
  jwtHmacSha512PrivateKey: '$(secret)'
  jwtRefreshTokenHashPepper: '$(secret)'

test:
  database: '$(secret)'
  healthKek: '$(kek)'
  emailSecretHashPepper: '$(secret)'
  jwtHmacSha512PrivateKey: '$(secret)'
  jwtRefreshTokenHashPepper: '$(secret)'
YAML
echo "Created $target"
