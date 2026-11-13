# Staging (test) environment of the Parla server on AWS, Frankfurt.
# Setup and day-to-day use: docs/RELEASE.md.

terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.95"
    }
  }

  # State lives in an S3 bucket of the same account; deploy/aws/init-staging.sh
  # creates the bucket and passes its name here. The state holds no secret
  # values: every secret is created outside Terraform.
  backend "s3" {}
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = "parla"
      Environment = "staging"
      ManagedBy   = "terraform"
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  account_id = data.aws_caller_identity.current.account_id
  azs        = slice(data.aws_availability_zones.available.names, 0, 2)
}
