#!/usr/bin/env bash
# Fills the production server's secret in AWS Secrets Manager, once.
#
# Random keys are generated here and never printed; production never
# reuses staging's keys. SMTP settings are asked for without echoing, so
# they never end up in shell history or in the repository, or, with
# --smtp-from-staging, copied from the old parla-staging/app secret
# without being shown. The database password is not asked for: RDS
# manages it.
#
# Refuses to overwrite an existing value: a new healthKek would make all
# stored health answers unreadable, and new peppers or JWT keys would sign
# everyone out.
#
# Usage: deploy/aws/put-prod-secrets.sh [--smtp-from-staging]
set -euo pipefail

secret=parla-prod/app
old_secret=parla-staging/app
region=eu-central-1

if aws secretsmanager get-secret-value --secret-id "$secret" \
  --region "$region" --query VersionId --output text >/dev/null 2>&1; then
  echo "$secret already has a value; not changing it." >&2
  exit 1
fi

ask() { # prompt; prints the answer
  local value
  read -r -s -p "$1: " value
  echo >&2
  printf '%s' "$value"
}

umask 077
file=$(mktemp)
smtp=$(mktemp)
trap 'rm -f "$file" "$smtp"' EXIT

if [ "${1:-}" = "--smtp-from-staging" ]; then
  aws secretsmanager get-secret-value --secret-id "$old_secret" \
    --region "$region" --query SecretString --output text |
    jq '{smtpHost, smtpPort, smtpUser, smtpPassword, smtpFrom}' >"$smtp"
  jq -e 'all(.[]; type == "string" and length > 0)' "$smtp" >/dev/null || {
    echo "$old_secret has no complete SMTP settings." >&2; exit 1; }
  echo "SMTP settings copied from $old_secret (not shown)." >&2
else
  jq -n \
    --arg smtpHost "$(ask 'SMTP host (e.g. smtp.gmail.com)')" \
    --arg smtpPort "$(ask 'SMTP port (587 or 465)')" \
    --arg smtpUser "$(ask 'SMTP user (info@anacan.az)')" \
    --arg smtpPassword "$(ask 'SMTP password or app password')" \
    --arg smtpFrom "$(ask 'From address (info@anacan.az)')" \
    '$ARGS.named' >"$smtp"
fi

jq -n \
  --arg serviceSecret "$(openssl rand -hex 32)" \
  --arg emailSecretHashPepper "$(openssl rand -hex 32)" \
  --arg jwtHmacSha512PrivateKey "$(openssl rand -hex 32)" \
  --arg jwtRefreshTokenHashPepper "$(openssl rand -hex 32)" \
  --arg healthKek "$(openssl rand -base64 32 | tr -d '\n')" \
  --arg pseudonymPepper "$(openssl rand -hex 32)" \
  --slurpfile smtp "$smtp" \
  '($ARGS.named | del(.smtp)) + $smtp[0]' >"$file"

aws secretsmanager put-secret-value --secret-id "$secret" --region "$region" \
  --secret-string "file://$file" >/dev/null
echo "stored $secret"
