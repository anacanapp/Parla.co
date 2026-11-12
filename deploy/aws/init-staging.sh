#!/usr/bin/env bash
# Prepares Terraform for the staging environment, once per shell (e.g. AWS
# CloudShell): creates the private, versioned S3 bucket that holds the
# Terraform state if it does not exist yet, then runs `terraform init`.
#
# Usage, from the repository root: deploy/aws/init-staging.sh
set -euo pipefail

region=eu-central-1
account=$(aws sts get-caller-identity --query Account --output text)
bucket="parla-tfstate-${account}"

if ! aws s3api head-bucket --bucket "$bucket" 2>/dev/null; then
  aws s3api create-bucket --bucket "$bucket" --region "$region" \
    --create-bucket-configuration LocationConstraint="$region" >/dev/null
  aws s3api put-public-access-block --bucket "$bucket" \
    --public-access-block-configuration \
    BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
  aws s3api put-bucket-versioning --bucket "$bucket" \
    --versioning-configuration Status=Enabled
  aws s3api put-bucket-encryption --bucket "$bucket" \
    --server-side-encryption-configuration \
    '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'
  echo "created state bucket $bucket"
fi

terraform -chdir="$(dirname "$0")/staging" init \
  -backend-config="bucket=${bucket}" \
  -backend-config="key=staging.tfstate" \
  -backend-config="region=${region}" \
  -backend-config="use_lockfile=true"
