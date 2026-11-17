variable "region" {
  description = "AWS region. Frankfurt keeps all data in the EU."
  type        = string
  default     = "eu-central-1"
}

variable "name" {
  description = "Prefix of every resource name."
  type        = string
  default     = "parla-staging"
}

variable "github_repository" {
  description = "Repository whose staging deploy workflow may deploy."
  type        = string
  default     = "anacanapp/Parla.co"
}

variable "create_github_oidc_provider" {
  description = <<-EOT
    An AWS account can hold only one GitHub OIDC provider. Set to false when
    the account already has one (IAM -> Identity providers ->
    token.actions.githubusercontent.com); it is then reused.
  EOT
  type        = bool
  default     = true
}

variable "db_instance_class" {
  description = "RDS instance size; the smallest is enough for testing."
  type        = string
  default     = "db.t4g.micro"
}

variable "task_cpu" {
  description = "Fargate CPU units for the server (256 = 0.25 vCPU)."
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Fargate memory for the server in MiB."
  type        = number
  default     = 512
}

variable "staff_bootstrap_email" {
  description = <<-EOT
    Email that may claim the first admin role of the admin panel while there
    is no staff yet. Not secret. Leave empty once the first admin exists.
  EOT
  type        = string
  default     = ""
}

variable "enable_push" {
  description = <<-EOT
    Pass the Firebase service account to the server (push notifications).
    Set to true only after deploy/aws/put-staging-fcm-secret.sh has stored
    it; otherwise the server task cannot start.
  EOT
  type        = bool
  default     = false
}
