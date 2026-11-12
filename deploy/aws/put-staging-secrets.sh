#!/usr/bin/env bash
# Fills the staging server's secret in AWS Secrets Manager, once.
#
# Random keys are generated here and never printed. SMTP settings are asked
# for without echoing, so they never end up in shell history or in the
# repository. The database password is not asked for: RDS manages it.
#
# Refuses to overwrite an existing value: a new healthKek would make all
# stored health answers unreadable, and new peppers or JWT keys would sign
# everyone out.
#
# Usage: deploy/aws/put-staging-secrets.sh
set -euo pipefail

secret=parla-staging/app
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

smtp_host=$(ask 'SMTP host (e.g. smtp.gmail.com)')
smtp_port=$(ask 'SMTP port (587 or 465)')
smtp_user=$(ask 'SMTP user (info@anacan.az)')
smtp_password=$(ask 'SMTP password or app password')
smtp_from=$(ask 'From address (info@anacan.az)')

umask 077
file=$(mktemp)
trap 'rm -f "$file"' EXIT

jq -n \
  --arg serviceSecret "$(openssl rand -hex 32)" \
  --arg emailSecretHashPepper "$(openssl rand -hex 32)" \
  --arg jwtHmacSha512PrivateKey "$(openssl rand -hex 32)" \
  --arg jwtRefreshTokenHashPepper "$(openssl rand -hex 32)" \
  --arg healthKek "$(openssl rand -base64 32 | tr -d '\n')" \
  --arg pseudonymPepper "$(openssl rand -hex 32)" \
  --arg smtpHost "$smtp_host" \
  --arg smtpPort "$smtp_port" \
  --arg smtpUser "$smtp_user" \
  --arg smtpPassword "$smtp_password" \
  --arg smtpFrom "$smtp_from" \
  '$ARGS.named' >"$file"

aws secretsmanager put-secret-value --secret-id "$secret" --region "$region" \
  --secret-string "file://$file" >/dev/null
echo "stored $secret"
