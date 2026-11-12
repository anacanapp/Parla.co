output "server_url" {
  description = "SERVER_URL for the app (Codemagic group parla_staging)."
  value       = "https://${aws_cloudfront_distribution.main.domain_name}/"
}

output "deploy_role_arn" {
  description = "GitHub variable AWS_DEPLOY_ROLE_ARN (environment staging)."
  value       = aws_iam_role.deploy.arn
}

output "ecr_repository_url" {
  value = aws_ecr_repository.server.repository_url
}

output "app_secret_name" {
  description = "Filled once by deploy/aws/put-staging-secrets.sh."
  value       = aws_secretsmanager_secret.app.name
}

output "log_group" {
  value = aws_cloudwatch_log_group.server.name
}
