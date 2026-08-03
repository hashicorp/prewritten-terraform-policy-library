# Copyright IBM Corp. 2026

# ELB.1: Application Load Balancer HTTP to HTTPS Redirection

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "alb-http-to-https-redirection-check-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_lb_listener" "http_to_https_redirect" {
  enforcement_level = input.alb-http-to-https-redirection-check-enforcement-level
  # Only evaluate HTTP listeners
  filter = core::try(attrs.protocol, "") == "HTTP"

  locals {
    default_actions = core::try(attrs.default_action, [])

    # A compliant default_action has type == "redirect" AND targets HTTPS protocol.
    https_redirect_actions = [
      for action in local.default_actions :
      action
      if core::try(action.type, "") == "redirect"
        && core::try(action.redirect.protocol, "") == "HTTPS"
    ]

    has_https_redirect = core::length(local.https_redirect_actions) > 0
  }

  enforce {
    condition     = local.has_https_redirect
    error_message = "Application Load Balancer HTTP listener must have a default_action of type 'redirect' that targets the HTTPS protocol. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/elb-controls.html#elb-1 for more details."
  }
}
