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
