# The server's own secrets (keys, peppers, SMTP) as one JSON secret. Only
# the empty secret is created here; deploy/aws/put-staging-secrets.sh fills
# it once, so the values never pass through Terraform or its state.

resource "aws_secretsmanager_secret" "app" {
  name                    = "${var.name}/app"
  description             = "Parla staging server secrets (SERVERPOD_PASSWORD_*)"
  kms_key_id              = aws_kms_key.main.arn
  recovery_window_in_days = 7
}

locals {
  # Keys of the JSON secret, each passed as SERVERPOD_PASSWORD_<key>.
  app_secret_keys = [
    "serviceSecret",
    "emailSecretHashPepper",
    "jwtHmacSha512PrivateKey",
    "jwtRefreshTokenHashPepper",
    "healthKek",
    "pseudonymPepper",
    "smtpHost",
    "smtpPort",
    "smtpUser",
    "smtpPassword",
    "smtpFrom",
  ]
}

# Push notifications (admin phase D3): the Firebase service account JSON.
# Created empty; deploy/aws/put-staging-fcm-secret.sh stores it once. The
# server reads it only when var.enable_push is true, so the task keeps
# starting while the secret is still empty.
resource "aws_secretsmanager_secret" "fcm" {
  name                    = "${var.name}/fcm"
  description             = "Firebase service account for push (SERVERPOD_PASSWORD_fcmServiceAccount)"
  kms_key_id              = aws_kms_key.main.arn
  recovery_window_in_days = 7
}
