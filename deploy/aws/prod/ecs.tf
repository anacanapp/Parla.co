# The Parla server as one always-on Fargate task: the daily retention job
# runs inside the server and must keep running. The task runs the image
# tagged "prod"; the deploy workflow pushes a new one and restarts it.

resource "aws_ecs_cluster" "main" {
  name = var.name
}

# Server logs stay in Frankfurt for 30 days (data map row 17).
resource "aws_cloudwatch_log_group" "server" {
  name              = "/${var.name}/server"
  retention_in_days = 30
  kms_key_id        = aws_kms_key.main.arn
}

# --- Roles ------------------------------------------------------------------

data "aws_iam_policy_document" "ecs_tasks_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Used by ECS to pull the image, write logs and read the secrets.
resource "aws_iam_role" "execution" {
  name               = "${var.name}-execution"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume.json
}

resource "aws_iam_role_policy_attachment" "execution" {
  role       = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "execution_secrets" {
  statement {
    actions = ["secretsmanager:GetSecretValue"]
    resources = [
      aws_secretsmanager_secret.app.arn,
      aws_secretsmanager_secret.fcm.arn,
      aws_secretsmanager_secret.epoint.arn,
      aws_db_instance.main.master_user_secret[0].secret_arn,
    ]
  }
  statement {
    actions   = ["kms:Decrypt"]
    resources = [aws_kms_key.main.arn]
  }
}

resource "aws_iam_role_policy" "execution_secrets" {
  name   = "secrets"
  role   = aws_iam_role.execution.id
  policy = data.aws_iam_policy_document.execution_secrets.json
}

# The server's own AWS access: the media bucket (media.tf) and the health
# data key KMS key (kms.tf, ENC-3).
resource "aws_iam_role" "task" {
  name               = "${var.name}-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume.json
}

# --- Task and service -------------------------------------------------------

locals {

  container_secrets = concat(
    [{
      name      = "SERVERPOD_PASSWORD_database"
      valueFrom = "${aws_db_instance.main.master_user_secret[0].secret_arn}:password::"
    }],
    [for key in local.app_secret_keys : {
      name      = "SERVERPOD_PASSWORD_${key}"
      valueFrom = "${aws_secretsmanager_secret.app.arn}:${key}::"
    }],
    var.enable_push ? [{
      name      = "SERVERPOD_PASSWORD_fcmServiceAccount"
      valueFrom = aws_secretsmanager_secret.fcm.arn
    }] : [],
    var.enable_shop_payments ? [
      for key in ["publicKey", "privateKey"] : {
        name      = "SERVERPOD_PASSWORD_epoint${title(key)}"
        valueFrom = "${aws_secretsmanager_secret.epoint.arn}:${key}::"
      }
    ] : [],
  )
}

resource "aws_ecs_task_definition" "server" {
  family                   = "${var.name}-server"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.execution.arn
  task_role_arn            = aws_iam_role.task.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([{
    name      = "server"
    image     = "${aws_ecr_repository.server.repository_url}:prod"
    essential = true

    # 8080: API server. 8082: web server (admin panel, published images).
    portMappings = [
      { containerPort = 8080, protocol = "tcp" },
      { containerPort = 8082, protocol = "tcp" },
    ]

    environment = [
      { name = "runmode", value = "production" },
      { name = "flags", value = "--apply-migrations" },
      { name = "SERVERPOD_DATABASE_HOST", value = aws_db_instance.main.address },
      { name = "SERVERPOD_DATABASE_PORT", value = tostring(aws_db_instance.main.port) },
      { name = "SERVERPOD_DATABASE_NAME", value = aws_db_instance.main.db_name },
      { name = "SERVERPOD_DATABASE_USER", value = aws_db_instance.main.username },
      { name = "SERVERPOD_API_SERVER_PUBLIC_HOST", value = var.domain },
      { name = "SERVERPOD_WEB_SERVER_PUBLIC_HOST", value = var.domain },
      { name = "SERVERPOD_PASSWORD_staffBootstrapEmail", value = var.staff_bootstrap_email },
      { name = "SERVERPOD_PASSWORD_shopSalesOpen", value = tostring(var.shop_sales_open && var.enable_shop_payments) },
      { name = "PARLA_MEDIA_BUCKET", value = aws_s3_bucket.media.bucket },
      { name = "PARLA_MEDIA_REGION", value = var.region },
      { name = "PARLA_HEALTH_KMS_KEY_ID", value = aws_kms_key.health.arn },
      { name = "PARLA_MEDIA_PUBLIC_URL", value = "https://${var.domain}/media" },
    ]

    secrets = local.container_secrets

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.server.name
        awslogs-region        = var.region
        awslogs-stream-prefix = "server"
      }
    }

    stopTimeout = 30
  }])
}

resource "aws_ecs_service" "server" {
  name             = "${var.name}-server"
  cluster          = aws_ecs_cluster.main.id
  task_definition  = aws_ecs_task_definition.server.arn
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  # Never two servers at once (one retention job, one image cache): a
  # deploy stops the old task before starting the new one, so the service
  # is away for about two minutes. Deploy at quiet hours.
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100
  health_check_grace_period_seconds  = 120

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.app.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.api.arn
    container_name   = "server"
    container_port   = 8080
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.web.arn
    container_name   = "server"
    container_port   = 8082
  }

  depends_on = [aws_lb_listener_rule.api, aws_lb_listener_rule.web]
}
