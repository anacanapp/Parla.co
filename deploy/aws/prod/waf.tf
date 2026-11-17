# AWS WAF in front of the load balancer.
#
# - AWS managed rules: known bad IP addresses, common web attacks and known
#   bad inputs.
# - Rate limits per IP address: sign-in (one-time codes by email, so abuse
#   would send mail from info@anacan.az) and all requests.
#
# Privacy: no WAF logs and no sampled requests are kept (they would store
# visitors' IP addresses and requests); only the counts in CloudWatch
# metrics. Mobile networks put many people behind one address, so the
# limits are generous; watch the BlockedRequests metric after launch.

resource "aws_wafv2_web_acl" "main" {
  count = var.enable_waf ? 1 : 0
  name  = var.name
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "aws-ip-reputation"
    priority = 0
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesAmazonIpReputationList"
      }
    }
    visibility_config {
      metric_name                = "aws-ip-reputation"
      cloudwatch_metrics_enabled = true
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "aws-common"
    priority = 1
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesCommonRuleSet"

        # Image uploads in the admin panel are up to 1.5 MiB (base64), far
        # over this rule's 8 KB body limit. The server enforces its own
        # maxRequestSize.
        rule_action_override {
          name = "SizeRestrictions_BODY"
          action_to_use {
            count {}
          }
        }
      }
    }
    visibility_config {
      metric_name                = "aws-common"
      cloudwatch_metrics_enabled = true
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "aws-known-bad-inputs"
    priority = 2
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
      }
    }
    visibility_config {
      metric_name                = "aws-known-bad-inputs"
      cloudwatch_metrics_enabled = true
      sampled_requests_enabled   = false
    }
  }

  # Sign-in, registration and staff sign-in all go to the email identity
  # provider endpoint.
  rule {
    name     = "rate-sign-in"
    priority = 10
    action {
      block {}
    }
    statement {
      rate_based_statement {
        limit                 = var.waf_sign_in_limit
        evaluation_window_sec = 300
        aggregate_key_type    = "IP"
        scope_down_statement {
          byte_match_statement {
            search_string         = "/emailIdp"
            positional_constraint = "STARTS_WITH"
            field_to_match {
              uri_path {}
            }
            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }
      }
    }
    visibility_config {
      metric_name                = "rate-sign-in"
      cloudwatch_metrics_enabled = true
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "rate-all"
    priority = 11
    action {
      block {}
    }
    statement {
      rate_based_statement {
        limit                 = var.waf_request_limit
        evaluation_window_sec = 300
        aggregate_key_type    = "IP"
      }
    }
    visibility_config {
      metric_name                = "rate-all"
      cloudwatch_metrics_enabled = true
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    metric_name                = var.name
    cloudwatch_metrics_enabled = true
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl_association" "main" {
  count        = var.enable_waf ? 1 : 0
  resource_arn = aws_lb.main.arn
  web_acl_arn  = aws_wafv2_web_acl.main[0].arn
}
