#!/usr/bin/env bash
# Creates the staging secrets in Google Secret Manager, once.
#
# Random secrets are generated here and never printed. Values only a person
# knows (database password, SMTP settings) are asked for interactively and
# not echoed, so they never end up in shell history or in the repository.
#
# Usage: deploy/create-staging-secrets.sh <gcp-project-id>
set -euo pipefail

project="${1:?usage: $0 <gcp-project-id>}"

create() { # name, value read from stdin
  gcloud secrets create "$1" --project="$project" \
    --replication-policy=user-managed --locations=europe-west3 \
    --data-file=- >/dev/null
  echo "created $1"
}

random_hex() { openssl rand -hex 32; }

random_hex | create parla-staging-service-secret
random_hex | create parla-staging-email-pepper
random_hex | create parla-staging-jwt-key
random_hex | create parla-staging-jwt-refresh-pepper
random_hex | create parla-staging-pseudonym-pepper
# 32-byte key-encryption key for health data, base64.
openssl rand -base64 32 | tr -d '\n' | create parla-staging-health-kek

ask() { # secret name, prompt
  local value
  read -r -s -p "$2: " value
  echo
  printf '%s' "$value" | create "$1"
}

ask parla-staging-database 'Supabase database password'
ask parla-staging-smtp-host 'SMTP host (e.g. smtp.gmail.com)'
ask parla-staging-smtp-port 'SMTP port (587 or 465)'
ask parla-staging-smtp-user 'SMTP user (info@anacan.az)'
ask parla-staging-smtp-password 'SMTP password or app password'
ask parla-staging-smtp-from 'From address (info@anacan.az)'
