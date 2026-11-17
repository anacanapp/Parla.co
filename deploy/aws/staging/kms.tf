# One customer-managed key for the database, its backups, the secrets and
# the server logs. Rotated yearly by AWS (privacy checklist ENC-4).

resource "aws_kms_key" "main" {
  description             = "${var.name}: database, secrets and logs"
  enable_key_rotation     = true
  deletion_window_in_days = 30
  policy                  = data.aws_iam_policy_document.kms.json
}

resource "aws_kms_alias" "main" {
  name          = "alias/${var.name}"
  target_key_id = aws_kms_key.main.key_id
}

data "aws_iam_policy_document" "kms" {
  # Account administrators manage the key; services use it through the IAM
  # permissions of their roles.
  statement {
    sid       = "AccountAdministration"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }
  }

  statement {
    sid = "CloudWatchLogs"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*",
    ]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["logs.${var.region}.amazonaws.com"]
    }
    condition {
      test     = "ArnLike"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = ["arn:aws:logs:${var.region}:${local.account_id}:log-group:/${var.name}/*"]
    }
  }
}

# Wraps every user's health data key (privacy checklist ENC-3). The key
# never leaves KMS; the server may only encrypt and decrypt with an
# encryption context naming the account ("parla:user"). Deleting a user's
# wrapped key in the database still shreds their health data.
resource "aws_kms_key" "health" {
  description             = "${var.name}: health data keys"
  enable_key_rotation     = true
  deletion_window_in_days = 30
}

resource "aws_kms_alias" "health" {
  name          = "alias/${var.name}-health"
  target_key_id = aws_kms_key.health.key_id
}

data "aws_iam_policy_document" "task_health_kms" {
  statement {
    actions   = ["kms:Encrypt", "kms:Decrypt"]
    resources = [aws_kms_key.health.arn]
    condition {
      test     = "Null"
      variable = "kms:EncryptionContext:parla:user"
      values   = ["false"]
    }
  }
}

resource "aws_iam_role_policy" "task_health_kms" {
  name   = "health-kms"
  role   = aws_iam_role.task.id
  policy = data.aws_iam_policy_document.task_health_kms.json
}
