#!/usr/bin/env bash
# Stores the Firebase service account (push notifications) in AWS Secrets
# Manager, once. Run it in CloudShell after uploading the JSON key file
# there (Actions -> Upload file). The file is deleted afterwards; never
# commit it or send it in chat.
#
# Usage: deploy/aws/put-prod-fcm-secret.sh path/to/service-account.json
set -euo pipefail

secret=parla-prod/fcm
region=eu-central-1
file=${1:?path to the service account JSON}

if aws secretsmanager get-secret-value --secret-id "$secret" \
  --region "$region" --query VersionId --output text >/dev/null 2>&1; then
  echo "$secret already has a value; not changing it." >&2
  exit 1
fi

jq -e '.type == "service_account" and .project_id and .private_key' \
  "$file" >/dev/null || { echo "Not a service account JSON file." >&2; exit 1; }

aws secretsmanager put-secret-value --secret-id "$secret" --region "$region" \
  --secret-string "file://$file" >/dev/null
shred -u "$file" 2>/dev/null || rm -f "$file"
echo "stored $secret and deleted $file"
