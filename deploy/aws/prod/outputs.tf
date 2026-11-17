output "server_url" {
  description = "SERVER_URL for the app (Codemagic group parla_prod)."
  value       = "https://${var.domain}/"
}

output "admin_url" {
  description = "The admin panel."
  value       = "https://${var.domain}/admin/"
}

output "media_url" {
  description = "Where the app loads published images from."
  value       = "https://${var.domain}/media/"
}

output "certificate_validation_record" {
  description = "Cloudflare: CNAME that proves the domain to ACM (DNS only)."
  value = [for o in aws_acm_certificate.main.domain_validation_options : {
    type  = o.resource_record_type
    name  = o.resource_record_name
    value = o.resource_record_value
  }]
}

output "load_balancer_dns_name" {
  description = "Cloudflare: CNAME target of the domain (DNS only)."
  value       = aws_lb.main.dns_name
}

output "deploy_role_arn" {
  description = "GitHub variable AWS_DEPLOY_ROLE_ARN (environment production)."
  value       = aws_iam_role.deploy.arn
}

output "ecr_repository_url" {
  value = aws_ecr_repository.server.repository_url
}

output "app_secret_name" {
  description = "Filled once by deploy/aws/put-prod-secrets.sh."
  value       = aws_secretsmanager_secret.app.name
}

output "fcm_secret_name" {
  description = "Filled by deploy/aws/put-prod-fcm-secret.sh before enable_push."
  value       = aws_secretsmanager_secret.fcm.name
}

output "log_group" {
  value = aws_cloudwatch_log_group.server.name
}
