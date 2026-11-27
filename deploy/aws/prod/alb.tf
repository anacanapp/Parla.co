# Public HTTPS entry point: https://parla.anacan.az/ (var.domain).
#
# Cloudflare only holds the DNS record ("DNS only", no proxy), so TLS ends
# here, in Frankfurt, with an ACM certificate; no other company sees the
# traffic. One address serves everything (same origin, so no CORS):
#
#   /admin, /admin/*  -> web server (8082): the admin panel
#   /media/*          -> web server (8082): images of published content
#   everything else   -> API server (8080)
#
# Requests for any other host name (for example the raw load balancer
# address) get a 404. HTTP only redirects to HTTPS. Access logs are off:
# they would store every visitor's IP address.

resource "aws_lb" "main" {
  name                       = var.name
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = aws_subnet.public[*].id
  security_groups            = [aws_security_group.alb.id]
  drop_invalid_header_fields = true
  desync_mitigation_mode     = "strictest"
  enable_deletion_protection = true
}

# --- Certificate ------------------------------------------------------------

# Validated by a CNAME record that is added by hand in Cloudflare (output
# certificate_validation_record). ACM renews it on its own while that
# record stays.
resource "aws_acm_certificate" "main" {
  domain_name       = var.domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Waits until ACM sees the Cloudflare record (first apply: see RELEASE.md).
resource "aws_acm_certificate_validation" "main" {
  certificate_arn = aws_acm_certificate.main.arn

  timeouts {
    create = "30m"
  }
}

# --- Target groups ----------------------------------------------------------

resource "aws_lb_target_group" "api" {
  name                 = "${var.name}-api"
  port                 = 8080
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = aws_vpc.main.id
  deregistration_delay = 30

  # Serverpod's readiness probe; it also checks the database connection.
  health_check {
    path                = "/readyz"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group" "web" {
  name                 = "${var.name}-web"
  port                 = 8082
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = aws_vpc.main.id
  deregistration_delay = 30

  # The panel's start page: a task whose image lacks the panel never
  # becomes healthy, so the deploy rolls back.
  health_check {
    path                = "/admin/"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

# --- Listeners --------------------------------------------------------------

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate_validation.main.certificate_arn

  # Security headers on every response (privacy checklist ENC-1). The
  # admin panel's content security policy is set by the server, because it
  # differs by path.
  routing_http_response_strict_transport_security_header_value = "max-age=31536000; includeSubDomains"
  routing_http_response_x_content_type_options_header_value    = "nosniff"
  routing_http_response_x_frame_options_header_value           = "DENY"
  routing_http_response_server_enabled                         = false

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "web" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 10

  condition {
    host_header {
      values = [var.domain]
    }
  }
  condition {
    path_pattern {
      # At most five values in one rule, the host included.
      values = ["/admin", "/admin/*", "/media/*", "/shop/*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

# The public website (parla_server/lib/src/site): its pages in az (/),
# ru (/ru) and en (/en), its files and the crawler files. Rules hold at
# most five values, the host included, so the paths are split in three.
locals {
  site_paths = [
    ["/", "/ru", "/en", "/site/*"],
    ["/ru/*", "/en/*", "/privacy", "/terms"],
    ["/blog", "/blog/*", "/robots.txt", "/sitemap.xml"],
  ]
}

resource "aws_lb_listener_rule" "site" {
  count        = length(local.site_paths)
  listener_arn = aws_lb_listener.https.arn
  priority     = 11 + count.index

  condition {
    host_header {
      values = [var.domain]
    }
  }
  condition {
    path_pattern {
      values = local.site_paths[count.index]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_lb_listener_rule" "api" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 20

  condition {
    host_header {
      values = [var.domain]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}
