# Copyright IBM Corp. 2026

# Ensure a log metric filter and alarm exist for unauthorized API calls

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "cloudwatch-unauthorized-api-calls-alarm-enforcement-level" {
  type    = string
  default = "advisory"
}

locals {
  unauth_all_metric_filters = core::getresources("aws_cloudwatch_log_metric_filter", {})

  unauthorized_api_filters = [
    for f in local.unauth_all_metric_filters : f
    if core::try(core::contains_substring(f.pattern, "UnauthorizedOperation"), false) &&
       core::try(core::contains_substring(f.pattern, "AccessDenied"), false)
  ]

  unauthorized_api_metric_names = [
    for f in local.unauthorized_api_filters :
    core::try(f.metric_transformation[0].name, "")
    if core::try(f.metric_transformation[0].name, "") != ""
  ]

  unauth_all_alarms = core::getresources("aws_cloudwatch_metric_alarm", {})

  unauth_compliant_alarms = [
    for alarm in local.unauth_all_alarms : alarm
    if core::contains(local.unauthorized_api_metric_names, core::try(alarm.metric_name, "")) &&
       core::try(alarm.threshold >= 0, false) &&
       core::try(alarm.threshold <= 1, false) &&
       core::try(alarm.comparison_operator, "") == "GreaterThanOrEqualToThreshold" &&
       core::try(core::length(alarm.alarm_actions) > 0, false)
  ]
}

resource_policy "aws_cloudwatch_log_metric_filter" "unauthorized_api_calls_filter" {
  enforcement_level = input.cloudwatch-unauthorized-api-calls-alarm-enforcement-level

  locals {
    pattern             = core::try(attrs.pattern, "")
    transformations     = core::try(attrs.metric_transformation, [])
    transformation_name = core::try(local.transformations[0].name, "")
    detects_unauthorized = core::contains_substring(local.pattern, "UnauthorizedOperation") && core::contains_substring(local.pattern, "AccessDenied")
    is_compliant        = local.detects_unauthorized && local.transformation_name != ""
  }

  enforce {
    condition     = local.is_compliant
    error_message = "CloudWatch log metric filter must detect unauthorized API calls by including 'UnauthorizedOperation' and 'AccessDenied' in the pattern and must emit a named metric. Required pattern: {($.errorCode=\"*UnauthorizedOperation\") || ($.errorCode=\"AccessDenied*\")}"
  }
}

resource_policy "aws_cloudwatch_metric_alarm" "unauthorized_api_calls_alarm" {
  enforcement_level = input.cloudwatch-unauthorized-api-calls-alarm-enforcement-level

  locals {
    metric_name              = core::try(attrs.metric_name, "")
    threshold                = core::try(attrs.threshold, -1)
    comparison               = core::try(attrs.comparison_operator, "")
    alarm_actions            = core::try(attrs.alarm_actions, [])
    references_correct_metric = core::contains(local.unauthorized_api_metric_names, local.metric_name)
    valid_threshold          = local.threshold >= 0 && local.threshold <= 1
    is_compliant             = local.references_correct_metric && local.valid_threshold && local.comparison == "GreaterThanOrEqualToThreshold" && core::length(local.alarm_actions) > 0
  }

  enforce {
    condition     = local.is_compliant
    error_message = "CloudWatch metric alarm for unauthorized API calls must reference an unauthorized-API metric filter, use threshold 0-1, use GreaterThanOrEqualToThreshold, and configure at least one alarm action."
  }
}

resource_policy "aws_sns_topic_subscription" "unauthorized_api_calls_subscription" {
  enforcement_level = input.cloudwatch-unauthorized-api-calls-alarm-enforcement-level

  locals {
    topic_arn       = core::try(attrs.topic_arn, "")
    matching_alarms = [
      for alarm in local.unauth_compliant_alarms : alarm
      if core::try(core::contains(alarm.alarm_actions, local.topic_arn), false)
    ]
    is_compliant = local.topic_arn != "" && core::length(local.matching_alarms) > 0
  }

  enforce {
    condition     = local.is_compliant
    error_message = "SNS topic subscription must attach to a topic used by a compliant unauthorized API calls alarm."
  }
}

