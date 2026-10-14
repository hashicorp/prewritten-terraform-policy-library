# Copyright IBM Corp. 2026

# CloudWatch alarms should have specified actions configured
policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.65.0, < 7.0.0"
    }
  }
}

input "cloudwatch-alarms-should-have-specified-actions-configured-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_cloudwatch_metric_alarm" "alarm_actions_configured" {
  locals {
    alarm_actions_raw = core::try(attrs.alarm_actions, null)
    alarm_actions     = local.alarm_actions_raw != null ? local.alarm_actions_raw : []
  }
  enforcement_level = input.cloudwatch-alarms-should-have-specified-actions-configured-enforcement-level
  enforce {
    condition     = core::length(local.alarm_actions) > 0
    error_message = "CloudWatch alarms must have alarm actions configured."
  }
}

resource_policy "aws_cloudwatch_composite_alarm" "alarm_actions_configured" {
  locals {
    alarm_actions_raw = core::try(attrs.alarm_actions, null)
    alarm_actions     = local.alarm_actions_raw != null ? local.alarm_actions_raw : []
  }

  enforcement_level = input.cloudwatch-alarms-should-have-specified-actions-configured-enforcement-level
  enforce {
    condition     = core::length(local.alarm_actions) > 0
    error_message = "CloudWatch alarms must have alarm actions configured."
  }
}
