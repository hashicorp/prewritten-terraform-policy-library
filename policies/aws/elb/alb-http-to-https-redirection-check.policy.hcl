# Copyright IBM Corp. 2026

# Application Load Balancer should be configured to redirect all HTTP requests to HTTPS

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.65.0, < 7.0.0"
    }
  }
}

input "alb-http-to-https-redirection-check-enforcement-level" {
  type    = string
  default = "advisory"
}

locals {
  alb_http_to_https_listeners      = core::getresources("aws_lb_listener", {})
  alb_http_to_https_listener_rules = core::getresources("aws_lb_listener_rule", {})
}

resource_policy "aws_lb" "http_to_https_redirect" {
  enforcement_level = input.alb-http-to-https-redirection-check-enforcement-level
  filter            = core::try(attrs.load_balancer_type, "application") == "application"

  locals {
    lb_arn = core::try(attrs.arn, "")

    http_listeners = [
      for listener in local.alb_http_to_https_listeners :
      listener
      if local.lb_arn != ""
        && core::try(listener.load_balancer_arn, "") != ""
        && core::try(listener.load_balancer_arn, "") == local.lb_arn
        && core::try(listener.protocol, "") == "HTTP"
    ]

    http_listener_arns = [
      for listener in local.http_listeners :
      core::try(listener.arn, "")
      if core::try(listener.arn, "") != ""
    ]

    default_actions = core::flatten([
      for listener in local.http_listeners :
      core::try(listener.default_action, [])
    ])

    listener_rule_actions = core::flatten([
      for rule in local.alb_http_to_https_listener_rules :
      core::try(rule.action, [])
      if core::try(rule.listener_arn, "") != ""
        && core::contains(local.http_listener_arns, core::try(rule.listener_arn, ""))
    ])

    default_https_redirect_actions = [
      for action in local.default_actions :
      action
      if core::try(action.type, "") == "redirect"
        && core::try(action.redirect[0].protocol, "") == "HTTPS"
    ]

    rule_https_redirect_actions = [
      for action in local.listener_rule_actions :
      action
      if core::try(action.type, "") == "redirect"
        && core::try(action.redirect[0].protocol, "") == "HTTPS"
    ]

    http_listeners_without_redirect = [
      for listener in local.http_listeners :
      listener
      if core::length([
        for action in core::try(listener.default_action, []) :
        action
        if core::try(action.type, "") == "redirect"
          && core::try(action.redirect[0].protocol, "") == "HTTPS"
      ]) + core::length([
        for rule in local.alb_http_to_https_listener_rules :
        rule
        if core::try(listener.arn, "") != ""
          && core::try(rule.listener_arn, "") == core::try(listener.arn, "")
          && core::length([
            for action in core::try(rule.action, []) :
            action
            if core::try(action.type, "") == "redirect"
              && core::try(action.redirect[0].protocol, "") == "HTTPS"
          ]) > 0
      ]) == 0
    ]

    has_http_listener = core::length(local.http_listeners) > 0
  }

  enforce {
    condition     = !local.has_http_listener || core::length(local.http_listeners_without_redirect) == 0
    error_message = "Every HTTP listener on an Application Load Balancer must have a redirect action that targets the HTTPS protocol, either in the listener default_action or an associated listener rule."
  }
}
