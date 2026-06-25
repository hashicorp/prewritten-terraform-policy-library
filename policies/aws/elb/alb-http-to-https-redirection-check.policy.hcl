# Copyright IBM Corp. 2026

# Policy: ELB.1 - Application Load Balancer should be configured to redirect all HTTP requests to HTTPS

policy {}

input "alb-http-to-https-redirection-check-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_lb_listener" "http_to_https_redirect" {
  enforcement_level = input.alb-http-to-https-redirection-check-enforcement-level
  filter = core::try(attrs.protocol, "") == "HTTP"

  locals {
    default_actions = core::try(attrs.default_action, [])

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
