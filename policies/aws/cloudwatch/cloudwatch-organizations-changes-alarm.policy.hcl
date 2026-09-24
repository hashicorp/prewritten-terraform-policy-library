# Copyright IBM Corp. 2026

# Ensure AWS Organizations changes are monitored (CIS 4.15)

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "cloudwatch-organizations-changes-alarm-enforcement-level" {
  type    = string
  default = "advisory"
}

locals {
  org_all_metric_filters = core::getresources("aws_cloudwatch_log_metric_filter", {})

  org_required_events = [
    "organizations.amazonaws.com",
    "AcceptHandshake",
    "AttachPolicy",
    "CreateAccount",
    "CreateOrganizationalUnit",
    "CreatePolicy",
    "DeclineHandshake",
    "DeleteOrganization",
    "DeleteOrganizationalUnit",
    "DeletePolicy",
    "DetachPolicy",
    "DisablePolicyType",
    "EnablePolicyType",
    "InviteAccountToOrganization",
    "LeaveOrganization",
    "MoveAccount",
    "RemoveAccountFromOrganization",
    "UpdatePolicy",
    "UpdateOrganizationalUnit",
  ]

  org_changes_filters = [
    for f in local.org_all_metric_filters : f
    if core::length([
      for event in local.org_required_events : event
      if core::try(core::contains_substring(f.pattern, event), false)
    ]) == core::length(local.org_required_events) &&
    core::try(f.metric_transformation[0].name, "") != "" &&
    core::try(f.metric_transformation[0].namespace, "") != "" &&
    core::try(f.metric_transformation[0].value, "") == "1" &&
    core::try(f.metric_transformation[0].default_value, "") == "0"
  ]

  org_changes_metric_names = [
    for f in local.org_changes_filters :
    core::try(f.metric_transformation[0].name, "")
    if core::try(f.metric_transformation[0].name, "") != ""
  ]

  org_changes_metric_namespaces = {
    for f in local.org_changes_filters :
    core::try(f.metric_transformation[0].name, "") => core::try(f.metric_transformation[0].namespace, "")
    if core::try(f.metric_transformation[0].name, "") != ""
  }

  org_all_alarms = core::getresources("aws_cloudwatch_metric_alarm", {})

  org_compliant_alarms = [
    for alarm in local.org_all_alarms : alarm
    if core::contains(local.org_changes_metric_names, core::try(alarm.metric_name, "")) &&
       core::try(local.org_changes_metric_namespaces[alarm.metric_name], "") == core::try(alarm.namespace, "") &&
       core::try(alarm.threshold >= 1, false) &&
       core::try(alarm.threshold <= 1, false) &&
       core::try(alarm.comparison_operator, "") == "GreaterThanOrEqualToThreshold" &&
       core::try(core::length(alarm.alarm_actions) > 0, false)
  ]

  org_all_sns_topics = core::getresources("aws_sns_topic", {})

  org_declared_topic_arns = [
    for t in local.org_all_sns_topics :
    core::try(t.arn, "")
    if core::try(t.arn, "") != ""
  ]
}

resource_policy "aws_cloudwatch_log_metric_filter" "org_changes_filter" {
  enforcement_level = input.cloudwatch-organizations-changes-alarm-enforcement-level

  locals {
    pattern             = core::try(attrs.pattern, "")
    transformations     = core::try(attrs.metric_transformation, [])
    transformation_name = core::try(local.transformations[0].name, "")
    transformation_ns   = core::try(local.transformations[0].namespace, "")
    transformation_val  = core::try(local.transformations[0].value, "")
    transformation_dval = core::try(local.transformations[0].default_value, "")
    detects_org_changes = core::length([
      for event in local.org_required_events : event
      if core::try(core::contains_substring(local.pattern, event), false)
    ]) == core::length(local.org_required_events)
    is_compliant = local.detects_org_changes && local.transformation_name != "" && local.transformation_ns != "" && local.transformation_val == "1" && local.transformation_dval == "0"
  }

  enforce {
    condition     = local.is_compliant
    error_message = "CloudWatch log metric filter must detect AWS Organizations changes by including 'organizations.amazonaws.com' and all required events in the pattern, emit a named metric with a non-empty namespace, value = \"1\", and default_value = \"0\"."
  }
}

resource_policy "aws_cloudwatch_metric_alarm" "org_changes_alarm" {
  enforcement_level = input.cloudwatch-organizations-changes-alarm-enforcement-level

  locals {
    metric_name               = core::try(attrs.metric_name, "")
    metric_namespace          = core::try(attrs.namespace, "")
    threshold                 = core::try(attrs.threshold, -1)
    comparison                = core::try(attrs.comparison_operator, "")
    alarm_actions             = core::try(attrs.alarm_actions, [])
    references_correct_metric = core::contains(local.org_changes_metric_names, local.metric_name)
    expected_namespace        = core::try(local.org_changes_metric_namespaces[local.metric_name], "")
    namespace_matches         = local.metric_namespace == local.expected_namespace && local.expected_namespace != ""
    valid_threshold           = local.threshold >= 1 && local.threshold <= 1
    is_compliant              = local.references_correct_metric && local.namespace_matches && local.valid_threshold && local.comparison == "GreaterThanOrEqualToThreshold" && core::length(local.alarm_actions) > 0
  }

  enforce {
    condition     = local.is_compliant
    error_message = "CloudWatch metric alarm for AWS Organizations changes must reference an organizations-changes metric filter by both metric name and namespace, use threshold 1, use GreaterThanOrEqualToThreshold, and configure at least one alarm action."
  }
}

resource_policy "aws_cloudtrail" "org_changes_trail" {
  enforcement_level = input.cloudwatch-organizations-changes-alarm-enforcement-level

  locals {
    has_cloudwatch_logs      = core::try(attrs.cloud_watch_logs_group_arn, "") != ""
    has_cloudwatch_logs_role = core::try(attrs.cloud_watch_logs_role_arn, "") != ""
    logging_enabled          = core::try(attrs.enable_logging, true)
    is_multi_region          = core::try(attrs.is_multi_region_trail, false)
    is_compliant             = local.has_cloudwatch_logs && local.has_cloudwatch_logs_role && local.logging_enabled && local.is_multi_region
  }

  enforce {
    condition     = local.is_compliant
    error_message = "CloudTrail trail must: have logging enabled, be a multi-region trail (is_multi_region_trail = true), set cloud_watch_logs_group_arn, and set cloud_watch_logs_role_arn. A trail without the delivery role cannot send events to CloudWatch Logs, and a single-region trail does not provide complete account coverage."
  }
}

resource_policy "aws_sns_topic_subscription" "org_changes_subscription" {
  enforcement_level = input.cloudwatch-organizations-changes-alarm-enforcement-level

  locals {
    topic_arn         = core::try(attrs.topic_arn, "")
    topic_is_declared = core::contains(local.org_declared_topic_arns, local.topic_arn)
    matching_alarms   = [
      for alarm in local.org_compliant_alarms : alarm
      if core::try(core::contains(alarm.alarm_actions, local.topic_arn), false)
    ]
    is_compliant = local.topic_arn != "" && local.topic_is_declared && core::length(local.matching_alarms) > 0
  }

  enforce {
    condition     = local.is_compliant
    error_message = "SNS topic subscription must reference a declared aws_sns_topic resource (not a dangling ARN) that is also referenced by a compliant AWS Organizations changes alarm."
  }
}
