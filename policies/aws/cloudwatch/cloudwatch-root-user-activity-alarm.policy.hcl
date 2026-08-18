# Copyright IBM Corp. 2026

# Ensure a log metric filter and alarm exist for root user usage (CIS 4.1 / CloudWatch.1)

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "cloudwatch-root-user-activity-alarm-enforcement-level" {
  type    = string
  default = "advisory"
}

locals {
  all_metric_filters = core::getresources("aws_cloudwatch_log_metric_filter", {})

  root_metric_filters = [
    for f in local.all_metric_filters : f
    if core::try(core::contains_substring(f.pattern, "userIdentity.type"), false) &&
       core::try(core::contains_substring(f.pattern, "Root"), false)
  ]

  root_metric_names = [
    for f in local.root_metric_filters :
    core::try(f.metric_transformation[0].name, "")
    if core::try(f.metric_transformation[0].name, "") != ""
  ]

  all_alarms = core::getresources("aws_cloudwatch_metric_alarm", {})

  compliant_alarms = [
    for alarm in local.all_alarms : alarm
    if core::contains(local.root_metric_names, core::try(alarm.metric_name, "")) &&
       core::try(alarm.threshold >= 0, false) &&
       core::try(alarm.threshold <= 1, false) &&
       core::try(alarm.comparison_operator, "") == "GreaterThanOrEqualToThreshold" &&
       core::try(core::length(alarm.alarm_actions) > 0, false)
  ]
}

resource_policy "aws_cloudwatch_log_metric_filter" "root_user_activity_filter" {
  enforcement_level = input.cloudwatch-root-user-activity-alarm-enforcement-level

  locals {
    pattern             = core::try(attrs.pattern, "")
    transformations     = core::try(attrs.metric_transformation, [])
    transformation_name = core::try(local.transformations[0].name, "")
    detects_root        = core::contains_substring(local.pattern, "userIdentity.type") && core::contains_substring(local.pattern, "Root")
    is_compliant        = local.detects_root && local.transformation_name != ""
  }

  enforce {
    condition     = local.is_compliant
    error_message = "CloudWatch log metric filter must detect root user activity by including 'userIdentity.type' and 'Root' in the pattern and must emit a named metric."
  }
}

resource_policy "aws_cloudwatch_metric_alarm" "root_user_activity_alarm" {
  enforcement_level = input.cloudwatch-root-user-activity-alarm-enforcement-level

  locals {
    metric_name   = core::try(attrs.metric_name, "")
    threshold     = core::try(attrs.threshold, -1)
    comparison    = core::try(attrs.comparison_operator, "")
    alarm_actions = core::try(attrs.alarm_actions, [])
    references_root_metric = core::contains(local.root_metric_names, local.metric_name)
    valid_threshold        = local.threshold >= 0 && local.threshold <= 1
    is_compliant           = local.references_root_metric && local.valid_threshold && local.comparison == "GreaterThanOrEqualToThreshold" && core::try(core::length(local.alarm_actions) > 0, false)
  }

  enforce {
    condition     = local.is_compliant
    error_message = "CloudWatch metric alarm for root user activity must reference a root-user metric filter, use threshold 0-1, use GreaterThanOrEqualToThreshold, and configure at least one alarm action."
  }
}

resource_policy "aws_sns_topic_subscription" "root_user_activity_subscription" {
  enforcement_level = input.cloudwatch-root-user-activity-alarm-enforcement-level

  locals {
    topic_arn       = core::try(attrs.topic_arn, "")
    matching_alarms = [
      for alarm in local.compliant_alarms : alarm
      if core::try(core::contains(alarm.alarm_actions, local.topic_arn), false)
    ]
    is_compliant = local.topic_arn != "" && core::length(local.matching_alarms) > 0
  }

  enforce {
    condition     = local.is_compliant
    error_message = "SNS topic subscription must attach to a topic used by a compliant root user activity alarm."
  }
}

