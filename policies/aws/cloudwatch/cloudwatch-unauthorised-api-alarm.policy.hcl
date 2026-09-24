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

input "cloudwatch-unauthorised-api-alarm-enforcement-level" {
  type    = string
  default = "advisory"
}

input "cloudwatch-unauthorised-api-alarm-metric-namespace" {
  type    = string
  default = "LogMetrics"
}


locals {
  unauth_api_metric_alarms      = core::getresources("aws_cloudwatch_metric_alarm", {})
  unauth_api_sns_topics         = core::getresources("aws_sns_topic", {})
  unauth_api_sns_subscriptions  = core::getresources("aws_sns_topic_subscription", {})
  unauth_api_metric_filters     = core::getresources("aws_cloudwatch_log_metric_filter", {})

  unauthorized_api_calls_pattern = "{($.errorCode=\"*UnauthorizedOperation\") || ($.errorCode=\"AccessDenied*\")}"

  unauth_api_valid_metric_filters = [
    for filter in local.unauth_api_metric_filters : filter
    if core::try(filter.pattern, "") == local.unauthorized_api_calls_pattern &&
       core::try(filter.metric_transformation[0].namespace, "") == input.cloudwatch-unauthorised-api-alarm-metric-namespace &&
       core::try(filter.metric_transformation[0].name, "") != "" &&
       core::try(filter.metric_transformation[0].value, "") == "1" &&
       core::try(filter.metric_transformation[0].default_value, "") == "0"
  ]

  unauth_api_valid_metrics = [
    for filter in local.unauth_api_valid_metric_filters : {
      name      = core::try(filter.metric_transformation[0].name, "")
      namespace = core::try(filter.metric_transformation[0].namespace, "")
    }
  ]

  unauth_api_valid_metric_alarms = [
    for alarm in local.unauth_api_metric_alarms : alarm
    if core::length([
      for metric in local.unauth_api_valid_metrics : metric
      if core::try(alarm.metric_name, "") == metric.name &&
         core::try(alarm.namespace, "") == metric.namespace
    ]) > 0 &&
    core::try(alarm.comparison_operator, "") == "GreaterThanOrEqualToThreshold" &&
    core::try(alarm.threshold, 0) == 1 &&
    core::length(core::try(alarm.alarm_actions, [])) > 0
  ]

  unauth_api_valid_sns_topics = [
    for topic in local.unauth_api_sns_topics : topic
    if core::length([
      for alarm in local.unauth_api_valid_metric_alarms : alarm
      if core::contains(
        core::try(alarm.alarm_actions, []),
        core::try(topic.arn, "")
      )
    ]) > 0
  ]

  unauth_api_valid_sns_topic_arns = [
    for topic in local.unauth_api_valid_sns_topics : core::try(topic.arn, "")
  ]
}

resource_policy "aws_cloudtrail" "cloudwatch-unauthorised-api-alarm" {
  enforcement_level = input.cloudwatch-unauthorised-api-alarm-enforcement-level

  locals {
    is_multi_region_trail      = core::try(attrs.is_multi_region_trail, false)
    enable_logging             = core::try(attrs.enable_logging, true)
    cloud_watch_logs_group_arn = core::try(attrs.cloud_watch_logs_group_arn, "")
    cloud_watch_logs_role_arn  = core::try(attrs.cloud_watch_logs_role_arn, "")

    is_compliant = local.is_multi_region_trail && local.enable_logging && local.cloud_watch_logs_group_arn != "" && local.cloud_watch_logs_role_arn != ""
  }

  enforce {
    condition = local.is_compliant

    error_message = "A multi-Region CloudTrail with CloudWatch Logs delivery should be configured."
  }
}

resource_policy "aws_cloudwatch_log_metric_filter" "cloudwatch-unauthorised-api-alarm" {
  enforcement_level = input.cloudwatch-unauthorised-api-alarm-enforcement-level

  locals {
    pattern                    = core::try(attrs.pattern, "")
    transformations            = core::try(attrs.metric_transformation, [])
    transformation_namespace   = core::try(local.transformations[0].namespace, "")
    transformation_name        = core::try(local.transformations[0].name, "")
    transformation_value       = core::try(local.transformations[0].value, "")
    transformation_default     = core::try(local.transformations[0].default_value, "")

    is_compliant = local.pattern == "{($.errorCode=\"*UnauthorizedOperation\") || ($.errorCode=\"AccessDenied*\")}" && local.transformation_namespace == input.cloudwatch-unauthorised-api-alarm-metric-namespace && local.transformation_name != "" && local.transformation_value == "1" && local.transformation_default == "0"
  }

  enforce {
    condition = local.is_compliant

    error_message = "An exact unauthorized API calls metric filter using the LogMetrics namespace, with metric value 1 and default value 0 is required."
  }
}

resource_policy "aws_cloudwatch_metric_alarm" "cloudwatch-unauthorised-api-alarm" {
  enforcement_level = input.cloudwatch-unauthorised-api-alarm-enforcement-level

  locals {
    metric_name          = core::try(attrs.metric_name, "")
    namespace            = core::try(attrs.namespace, "")
    comparison_operator  = core::try(attrs.comparison_operator, "")
    threshold             = core::try(attrs.threshold, 0)
    alarm_actions         = core::try(attrs.alarm_actions, [])

    references_valid_metric = core::length([
      for metric in local.unauth_api_valid_metrics : metric
      if metric.name == local.metric_name &&
         metric.namespace == local.namespace
    ]) > 0

    actions_reference_declared_topic = core::length([
      for action in local.alarm_actions : action
      if core::contains(
        [for t in local.unauth_api_sns_topics : core::try(t.arn, "")],
        action
      )
    ]) > 0

    is_compliant = local.references_valid_metric && local.comparison_operator == "GreaterThanOrEqualToThreshold" && local.threshold == 1 && local.actions_reference_declared_topic
  }

  enforce {
    condition = local.is_compliant

    error_message = "A CloudWatch alarm referencing the unauthorized API calls metric, using GreaterThanOrEqualToThreshold with a threshold of 1 and at least one alarm action targeting a declared aws_sns_topic resource is required."
  }
}

resource_policy "aws_sns_topic_subscription" "cloudwatch-unauthorised-api-alarm" {
  enforcement_level = input.cloudwatch-unauthorised-api-alarm-enforcement-level

  locals {
    topic_arn = core::try(attrs.topic_arn, "")

    is_compliant = local.topic_arn != "" && core::contains(local.unauth_api_valid_sns_topic_arns, local.topic_arn)
  }

  enforce {
    condition = local.is_compliant

    error_message = "An SNS topic subscription for a topic used by a compliant unauthorized API calls CloudWatch alarm is required."
  }
}
