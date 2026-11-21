variable "region" {
  description = "AWS region. Frankfurt keeps all data in the EU."
  type        = string
  default     = "eu-central-1"
}

variable "name" {
  description = "Prefix of every resource name."
  type        = string
  default     = "parla-prod"
}

variable "github_repository" {
  description = "Repository whose production deploy workflow may deploy."
  type        = string
  default     = "anacanapp/Parla.co"
}

variable "github_owner_id" {
  description = "Numeric id of the repository owner (GitHub API: owner.id)."
  type        = string
  default     = "340102032"
}

variable "github_repository_id" {
  description = "Numeric id of the repository (GitHub API: id)."
  type        = string
  default     = "1453947124"
}

variable "create_github_oidc_provider" {
  description = <<-EOT
    An AWS account can hold only one GitHub OIDC provider. Leave false when
    the account already has one (IAM -> Identity providers ->
    token.actions.githubusercontent.com); it is then reused. This account
    has one.
  EOT
  type        = bool
  default     = false
}

variable "domain" {
  description = <<-EOT
    Public host name. Its DNS is at Cloudflare ("DNS only", no proxy): a
    CNAME to the load balancer, plus the certificate's validation CNAME.
  EOT
  type        = string
  default     = "parla.anacan.az"
}

variable "db_instance_class" {
  description = "RDS instance size; the smallest is enough for the beta."
  type        = string
  default     = "db.t4g.micro"
}

variable "db_multi_az" {
  description = <<-EOT
    A standby database in a second availability zone (about twice the
    database cost). Off for the beta; turning it on later is an in-place
    change.
  EOT
  type        = bool
  default     = false
}

variable "db_backup_days" {
  description = "Days of automatic backups and point-in-time restore."
  type        = number
  default     = 14
}

variable "task_cpu" {
  description = "Fargate CPU units for the server (512 = 0.5 vCPU)."
  type        = number
  default     = 512
}

variable "task_memory" {
  description = "Fargate memory for the server in MiB."
  type        = number
  default     = 1024
}

variable "enable_waf" {
  description = "AWS WAF in front of the load balancer (waf.tf)."
  type        = bool
  default     = true
}

variable "waf_sign_in_limit" {
  description = "Sign-in requests per IP address in 5 minutes before WAF blocks."
  type        = number
  default     = 100
}

variable "waf_request_limit" {
  description = "Requests per IP address in 5 minutes before WAF blocks."
  type        = number
  default     = 3000
}

variable "staff_bootstrap_email" {
  description = <<-EOT
    Email that may claim the first admin role of the admin panel while there
    is no staff yet. Not secret. Leave empty once the first admin exists.
  EOT
  type        = string
  default     = ""
}

variable "enable_shop_payments" {
  description = <<-EOT
    Pass Epoint's merchant keys to the server (in-app Shop payments). Set
    to true only after deploy/aws/put-prod-epoint-secret.sh has stored
    them; otherwise the server task cannot start.
  EOT
  type        = bool
  default     = false
}

variable "shop_sales_open" {
  description = <<-EOT
    Offer products sold in the app. Needs enable_shop_payments, a signed
    Epoint contract, the result URL set in Epoint's cabinet, the delivery
    details step and the lawyer's sale terms.
  EOT
  type        = bool
  default     = false
}

variable "enable_push" {
  description = <<-EOT
    Pass the Firebase service account to the server (push notifications).
    Set to true only after deploy/aws/put-prod-fcm-secret.sh has stored
    it; otherwise the server task cannot start.
  EOT
  type        = bool
  default     = false
}
