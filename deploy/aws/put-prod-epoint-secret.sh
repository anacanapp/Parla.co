#!/usr/bin/env bash
# Stores Epoint's merchant keys in AWS Secrets Manager, once.
#
# The keys are asked for without echoing, so they never end up in shell
# history, the repository or Terraform state. Run it in AWS CloudShell.
# Refuses to overwrite an existing value: change keys in the console.
#
# Then set enable_shop_payments = true and apply Terraform.
#
# Usage: deploy/aws/put-prod-epoint-secret.sh
set -euo pipefail

secret=parla-prod/epoint
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
trap 'rm -f "$file"' EXIT

jq -n \
  --arg publicKey "$(ask 'Epoint public key (e.g. i000000001)')" \
  --arg privateKey "$(ask 'Epoint private key')" \
  '$ARGS.named' >"$file"
jq -e 'all(.[]; type == "string" and length > 0)' "$file" >/dev/null || {
  echo "Both keys are needed." >&2; exit 1; }

aws secretsmanager put-secret-value --secret-id "$secret" --region "$region" \
  --secret-string "file://$file" >/dev/null
echo "stored $secret"
