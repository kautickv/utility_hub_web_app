# Create IP Set for the IP addresses to allow
resource "aws_wafv2_ip_set" "allow_specific_ips" {
  name               = "AllowedIPs"
  description        = "An IP set to allow traffic only from specific IP addresses"
  scope              = "CLOUDFRONT" 
  ip_address_version = "IPV4"

  addresses = [
    "165.225.211.56/32"
  ]
}

# Create WAF Web ACL
resource "aws_wafv2_web_acl" "waf_web_acl" {
  name        = "${var.app_name}-waf"
  description = "AWS WAF WebACL for ${var.app_name}"
  scope       = "CLOUDFRONT"

  default_action {
    block {
      custom_response = {
        response_code="403"
      }
    }
  }

  rule {
    name     = "rule-1"
    priority = 1

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.allow_specific_ips.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "friendly-rule-metric-name"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.app_name}-waf-logs"
    sampled_requests_enabled   = true
  }
}