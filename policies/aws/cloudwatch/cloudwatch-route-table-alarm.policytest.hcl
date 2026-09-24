# Copyright IBM Corp. 2026

policytest {
  targets = ["cloudwatch-route-table-alarm.policy.hcl"]
}

# PASSING - Complete valid CloudWatch.13 chain
resource "aws_cloudtrail" "cloudwatch_13_pass" {
  attrs = {
    is_multi_region_trail        = true
    enable_logging               = true
    cloud_watch_logs_group_arn   = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-logs"
    cloud_watch_logs_role_arn    = "arn:aws:iam::123456789012:role/CloudTrailRole"
  }
}

resource "aws_cloudwatch_log_group" "cloudwatch_13_pass" {
  skip = true
  attrs = {
    name = "cloudtrail-logs"
    arn  = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-logs"
  }
}

resource "aws_cloudwatch_log_metric_filter" "cloudwatch_13_pass" {
  attrs = {
    log_group_name = "cloudtrail-logs"
    pattern        = "{($.eventSource=ec2.amazonaws.com) && (($.eventName=CreateRoute) || ($.eventName=CreateRouteTable) || ($.eventName=ReplaceRoute) || ($.eventName=ReplaceRouteTableAssociation) || ($.eventName=DeleteRouteTable) || ($.eventName=DeleteRoute) || ($.eventName=DisassociateRouteTable))}"
    metric_transformation = [
      {
        namespace     = "LogMetrics"
        name          = "RouteTableChanges"
        value         = "1"
        default_value = "0"
      }
    ]
  }
}

resource "aws_cloudwatch_metric_alarm" "cloudwatch_13_pass" {
  attrs = {
    metric_name         = "RouteTableChanges"
    namespace           = "LogMetrics"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    threshold           = 1
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:route-table-changes"]
  }
}

resource "aws_sns_topic" "cloudwatch_13_pass" {
  skip = true
  attrs = {
    name = "route-table-changes"
    arn  = "arn:aws:sns:us-east-1:123456789012:route-table-changes"
  }
}

resource "aws_sns_topic_subscription" "cloudwatch_13_pass" {
  attrs = {
    topic_arn = "arn:aws:sns:us-east-1:123456789012:route-table-changes"
    protocol  = "email"
    endpoint  = "admin@example.com"
  }
}

# FAILING - CloudTrail is not multi-region
resource "aws_cloudtrail" "single_region_trail" {
  expect_failure = true
  attrs = {
    is_multi_region_trail        = false
    enable_logging               = true
    cloud_watch_logs_group_arn   = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-logs"
    cloud_watch_logs_role_arn    = "arn:aws:iam::123456789012:role/CloudTrailRole"
  }
}

resource "aws_cloudwatch_log_group" "single_region_trail" {
  skip = true
  attrs = {
    name = "cloudtrail-logs"
    arn  = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-logs"
  }
}

resource "aws_cloudwatch_log_metric_filter" "single_region_trail" {
  skip = true
  attrs = {
    log_group_name = "cloudtrail-logs"
    pattern        = "{($.eventSource=ec2.amazonaws.com) && (($.eventName=CreateRoute) || ($.eventName=CreateRouteTable) || ($.eventName=ReplaceRoute) || ($.eventName=ReplaceRouteTableAssociation) || ($.eventName=DeleteRouteTable) || ($.eventName=DeleteRoute) || ($.eventName=DisassociateRouteTable))}"
    metric_transformation = [
      {
        namespace     = "LogMetrics"
        name          = "RouteTableChanges_SingleRegion"
        value         = "1"
        default_value = "0"
      }
    ]
  }
}

resource "aws_cloudwatch_metric_alarm" "single_region_trail" {
  skip = true
  attrs = {
    metric_name         = "RouteTableChanges_SingleRegion"
    namespace           = "LogMetrics"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    threshold           = 1
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:route-table-changes-single-region"]
  }
}

resource "aws_sns_topic" "single_region_trail" {
  skip = true
  attrs = {
    name = "route-table-changes-single-region"
    arn  = "arn:aws:sns:us-east-1:123456789012:route-table-changes-single-region"
  }
}

resource "aws_sns_topic_subscription" "single_region_trail" {
  skip = true
  attrs = {
    topic_arn = "arn:aws:sns:us-east-1:123456789012:route-table-changes-single-region"
    protocol  = "email"
    endpoint  = "admin@example.com"
  }
}

# FAILING - CloudTrail logging is disabled
resource "aws_cloudtrail" "logging_disabled" {
  expect_failure = true
  attrs = {
    is_multi_region_trail        = true
    enable_logging               = false
    cloud_watch_logs_group_arn   = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-logs"
    cloud_watch_logs_role_arn    = "arn:aws:iam::123456789012:role/CloudTrailRole"
  }
}

resource "aws_cloudwatch_log_group" "logging_disabled" {
  skip = true
  attrs = {
    name = "cloudtrail-logs"
    arn  = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-logs"
  }
}

resource "aws_cloudwatch_log_metric_filter" "logging_disabled" {
  skip = true
  attrs = {
    log_group_name = "cloudtrail-logs"
    pattern        = "{($.eventSource=ec2.amazonaws.com) && (($.eventName=CreateRoute) || ($.eventName=CreateRouteTable) || ($.eventName=ReplaceRoute) || ($.eventName=ReplaceRouteTableAssociation) || ($.eventName=DeleteRouteTable) || ($.eventName=DeleteRoute) || ($.eventName=DisassociateRouteTable))}"
    metric_transformation = [
      {
        namespace     = "LogMetrics"
        name          = "RouteTableChanges_LoggingDisabled"
        value         = "1"
        default_value = "0"
      }
    ]
  }
}

resource "aws_cloudwatch_metric_alarm" "logging_disabled" {
  skip = true
  attrs = {
    metric_name         = "RouteTableChanges_LoggingDisabled"
    namespace           = "LogMetrics"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    threshold           = 1
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:route-table-changes-logging-disabled"]
  }
}

resource "aws_sns_topic" "logging_disabled" {
  skip = true
  attrs = {
    name = "route-table-changes-logging-disabled"
    arn  = "arn:aws:sns:us-east-1:123456789012:route-table-changes-logging-disabled"
  }
}

resource "aws_sns_topic_subscription" "logging_disabled" {
  skip = true
  attrs = {
    topic_arn = "arn:aws:sns:us-east-1:123456789012:route-table-changes-logging-disabled"
    protocol  = "email"
    endpoint  = "admin@example.com"
  }
}

# FAILING - CloudWatch Logs group ARN is missing
resource "aws_cloudtrail" "no_cloudwatch_logs_group_arn" {
  expect_failure = true
  attrs = {
    is_multi_region_trail        = true
    enable_logging               = true
    cloud_watch_logs_group_arn   = ""
    cloud_watch_logs_role_arn    = "arn:aws:iam::123456789012:role/CloudTrailRole"
  }
}

resource "aws_cloudwatch_log_metric_filter" "no_cloudwatch_logs_group_arn" {
  skip = true
  attrs = {
    log_group_name = "cloudtrail-logs"
    pattern        = "{($.eventSource=ec2.amazonaws.com) && (($.eventName=CreateRoute) || ($.eventName=CreateRouteTable) || ($.eventName=ReplaceRoute) || ($.eventName=ReplaceRouteTableAssociation) || ($.eventName=DeleteRouteTable) || ($.eventName=DeleteRoute) || ($.eventName=DisassociateRouteTable))}"
    metric_transformation = [
      {
        namespace     = "LogMetrics"
        name          = "RouteTableChanges_NoGroupArn"
        value         = "1"
        default_value = "0"
      }
    ]
  }
}

resource "aws_cloudwatch_metric_alarm" "no_cloudwatch_logs_group_arn" {
  skip = true
  attrs = {
    metric_name         = "RouteTableChanges_NoGroupArn"
    namespace           = "LogMetrics"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    threshold           = 1
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:route-table-changes-no-group-arn"]
  }
}

resource "aws_sns_topic" "no_cloudwatch_logs_group_arn" {
  skip = true
  attrs = {
    name = "route-table-changes-no-group-arn"
    arn  = "arn:aws:sns:us-east-1:123456789012:route-table-changes-no-group-arn"
  }
}

resource "aws_sns_topic_subscription" "no_cloudwatch_logs_group_arn" {
  skip = true
  attrs = {
    topic_arn = "arn:aws:sns:us-east-1:123456789012:route-table-changes-no-group-arn"
    protocol  = "email"
    endpoint  = "admin@example.com"
  }
}

# FAILING - CloudWatch Logs role ARN is missing
resource "aws_cloudtrail" "no_cloudwatch_logs_role_arn" {
  expect_failure = true
  attrs = {
    is_multi_region_trail        = true
    enable_logging               = true
    cloud_watch_logs_group_arn   = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-logs"
    cloud_watch_logs_role_arn    = ""
  }
}

resource "aws_cloudwatch_log_group" "no_cloudwatch_logs_role_arn" {
  skip = true
  attrs = {
    name = "cloudtrail-logs"
    arn  = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-logs"
  }
}

resource "aws_cloudwatch_log_metric_filter" "no_cloudwatch_logs_role_arn" {
  skip = true
  attrs = {
    log_group_name = "cloudtrail-logs"
    pattern        = "{($.eventSource=ec2.amazonaws.com) && (($.eventName=CreateRoute) || ($.eventName=CreateRouteTable) || ($.eventName=ReplaceRoute) || ($.eventName=ReplaceRouteTableAssociation) || ($.eventName=DeleteRouteTable) || ($.eventName=DeleteRoute) || ($.eventName=DisassociateRouteTable))}"
    metric_transformation = [
      {
        namespace     = "LogMetrics"
        name          = "RouteTableChanges_NoRoleArn"
        value         = "1"
        default_value = "0"
      }
    ]
  }
}

resource "aws_cloudwatch_metric_alarm" "no_cloudwatch_logs_role_arn" {
  skip = true
  attrs = {
    metric_name         = "RouteTableChanges_NoRoleArn"
    namespace           = "LogMetrics"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    threshold           = 1
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:route-table-changes-no-role-arn"]
  }
}

resource "aws_sns_topic" "no_cloudwatch_logs_role_arn" {
  skip = true
  attrs = {
    name = "route-table-changes-no-role-arn"
    arn  = "arn:aws:sns:us-east-1:123456789012:route-table-changes-no-role-arn"
  }
}

resource "aws_sns_topic_subscription" "no_cloudwatch_logs_role_arn" {
  skip = true
  attrs = {
    topic_arn = "arn:aws:sns:us-east-1:123456789012:route-table-changes-no-role-arn"
    protocol  = "email"
    endpoint  = "admin@example.com"
  }
}

# FAILING - CloudWatch Logs metric filter references a log group not present as a resource
# The metric alarm references a metric name not produced by any valid filter, so alarm fails
resource "aws_cloudtrail" "log_group_not_found" {
  attrs = {
    is_multi_region_trail        = true
    enable_logging               = true
    cloud_watch_logs_group_arn   = "arn:aws:logs:us-east-1:123456789012:log-group:nonexistent-logs"
    cloud_watch_logs_role_arn    = "arn:aws:iam::123456789012:role/CloudTrailRole"
  }
}

resource "aws_cloudwatch_log_metric_filter" "log_group_not_found" {
  skip = true
  attrs = {
    log_group_name = "cloudtrail-logs"
    pattern        = "{($.eventSource=ec2.amazonaws.com) && (($.eventName=CreateRoute) || ($.eventName=CreateRouteTable) || ($.eventName=ReplaceRoute) || ($.eventName=ReplaceRouteTableAssociation) || ($.eventName=DeleteRouteTable) || ($.eventName=DeleteRoute) || ($.eventName=DisassociateRouteTable))}"
    metric_transformation = [
      {
        namespace     = "LogMetrics"
        name          = "RouteTableChanges_LogGroupNotFound"
        value         = "1"
        default_value = "0"
      }
    ]
  }
}

resource "aws_cloudwatch_metric_alarm" "log_group_not_found" {
  attrs = {
    metric_name         = "RouteTableChanges_LogGroupNotFound"
    namespace           = "LogMetrics"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    threshold           = 1
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:route-table-changes-log-group-not-found"]
  }
}

resource "aws_sns_topic" "log_group_not_found" {
  skip = true
  attrs = {
    name = "route-table-changes-log-group-not-found"
    arn  = "arn:aws:sns:us-east-1:123456789012:route-table-changes-log-group-not-found"
  }
}

resource "aws_sns_topic_subscription" "log_group_not_found" {
  attrs = {
    topic_arn = "arn:aws:sns:us-east-1:123456789012:route-table-changes-log-group-not-found"
    protocol  = "email"
    endpoint  = "admin@example.com"
  }
}

# FAILING - No metric filter resource exists; alarm references a metric with no valid filter
resource "aws_cloudtrail" "no_metric_filter" {
  attrs = {
    is_multi_region_trail        = true
    enable_logging               = true
    cloud_watch_logs_group_arn   = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-logs"
    cloud_watch_logs_role_arn    = "arn:aws:iam::123456789012:role/CloudTrailRole"
  }
}

resource "aws_cloudwatch_log_group" "no_metric_filter" {
  skip = true
  attrs = {
    name = "cloudtrail-logs"
    arn  = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-logs"
  }
}

resource "aws_cloudwatch_metric_alarm" "no_metric_filter" {
  expect_failure = true
  attrs = {
    metric_name         = "RouteTableChanges_NoFilter"
    namespace           = "LogMetrics"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    threshold           = 1
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:route-table-changes-no-filter"]
  }
}

resource "aws_sns_topic" "no_metric_filter" {
  skip = true
  attrs = {
    name = "route-table-changes-no-filter"
    arn  = "arn:aws:sns:us-east-1:123456789012:route-table-changes-no-filter"
  }
}

resource "aws_sns_topic_subscription" "no_metric_filter" {
  expect_failure = true
  attrs = {
    topic_arn = "arn:aws:sns:us-east-1:123456789012:route-table-changes-no-filter"
    protocol  = "email"
    endpoint  = "admin@example.com"
  }
}

# FAILING - Metric filter pattern does not match the required route-table pattern
resource "aws_cloudtrail" "incorrect_metric_pattern" {
  attrs = {
    is_multi_region_trail        = true
    enable_logging               = true
    cloud_watch_logs_group_arn   = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-logs"
    cloud_watch_logs_role_arn    = "arn:aws:iam::123456789012:role/CloudTrailRole"
  }
}

resource "aws_cloudwatch_log_group" "incorrect_metric_pattern" {
  skip = true
  attrs = {
    name = "cloudtrail-logs"
    arn  = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-logs"
  }
}

resource "aws_cloudwatch_log_metric_filter" "incorrect_metric_pattern" {
  expect_failure = true
  attrs = {
    log_group_name = "cloudtrail-logs"
    pattern        = "{($.eventSource=s3.amazonaws.com)}"
    metric_transformation = [
      {
        namespace     = "LogMetrics"
        name          = "RouteTableChanges_BadPattern"
        value         = "1"
        default_value = "0"
      }
    ]
  }
}

resource "aws_cloudwatch_metric_alarm" "incorrect_metric_pattern" {
  expect_failure = true
  attrs = {
    metric_name         = "RouteTableChanges_BadPattern"
    namespace           = "LogMetrics"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    threshold           = 1
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:route-table-changes-bad-pattern"]
  }
}

resource "aws_sns_topic" "incorrect_metric_pattern" {
  skip = true
  attrs = {
    name = "route-table-changes-bad-pattern"
    arn  = "arn:aws:sns:us-east-1:123456789012:route-table-changes-bad-pattern"
  }
}

resource "aws_sns_topic_subscription" "incorrect_metric_pattern" {
  expect_failure = true
  attrs = {
    topic_arn = "arn:aws:sns:us-east-1:123456789012:route-table-changes-bad-pattern"
    protocol  = "email"
    endpoint  = "admin@example.com"
  }
}

# FAILING - Metric filter namespace is not "LogMetrics"
resource "aws_cloudtrail" "wrong_metric_namespace" {
  attrs = {
    is_multi_region_trail        = true
    enable_logging               = true
    cloud_watch_logs_group_arn   = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-logs"
    cloud_watch_logs_role_arn    = "arn:aws:iam::123456789012:role/CloudTrailRole"
  }
}

resource "aws_cloudwatch_log_group" "wrong_metric_namespace" {
  skip = true
  attrs = {
    name = "cloudtrail-logs"
    arn  = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-logs"
  }
}

resource "aws_cloudwatch_log_metric_filter" "wrong_metric_namespace" {
  expect_failure = true
  attrs = {
    log_group_name = "cloudtrail-logs"
    pattern        = "{($.eventSource=ec2.amazonaws.com) && (($.eventName=CreateRoute) || ($.eventName=CreateRouteTable) || ($.eventName=ReplaceRoute) || ($.eventName=ReplaceRouteTableAssociation) || ($.eventName=DeleteRouteTable) || ($.eventName=DeleteRoute) || ($.eventName=DisassociateRouteTable))}"
    metric_transformation = [
      {
        namespace     = "CustomMetrics"
        name          = "RouteTableChanges_WrongNS"
        value         = "1"
        default_value = "0"
      }
    ]
  }
}

resource "aws_cloudwatch_metric_alarm" "wrong_metric_namespace" {
  expect_failure = true
  attrs = {
    metric_name         = "RouteTableChanges_WrongNS"
    namespace           = "CustomMetrics"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    threshold           = 1
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:route-table-changes-wrong-ns"]
  }
}

resource "aws_sns_topic" "wrong_metric_namespace" {
  skip = true
  attrs = {
    name = "route-table-changes-wrong-ns"
    arn  = "arn:aws:sns:us-east-1:123456789012:route-table-changes-wrong-ns"
  }
}

resource "aws_sns_topic_subscription" "wrong_metric_namespace" {
  expect_failure = true
  attrs = {
    topic_arn = "arn:aws:sns:us-east-1:123456789012:route-table-changes-wrong-ns"
    protocol  = "email"
    endpoint  = "admin@example.com"
  }
}

# FAILING - Metric filter value is "2" instead of "1"
resource "aws_cloudtrail" "wrong_metric_value" {
  attrs = {
    is_multi_region_trail        = true
    enable_logging               = true
    cloud_watch_logs_group_arn   = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-logs"
    cloud_watch_logs_role_arn    = "arn:aws:iam::123456789012:role/CloudTrailRole"
  }
}

resource "aws_cloudwatch_log_group" "wrong_metric_value" {
  skip = true
  attrs = {
    name = "cloudtrail-logs"
    arn  = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-logs"
  }
}

resource "aws_cloudwatch_log_metric_filter" "wrong_metric_value" {
  expect_failure = true
  attrs = {
    log_group_name = "cloudtrail-logs"
    pattern        = "{($.eventSource=ec2.amazonaws.com) && (($.eventName=CreateRoute) || ($.eventName=CreateRouteTable) || ($.eventName=ReplaceRoute) || ($.eventName=ReplaceRouteTableAssociation) || ($.eventName=DeleteRouteTable) || ($.eventName=DeleteRoute) || ($.eventName=DisassociateRouteTable))}"
    metric_transformation = [
      {
        namespace     = "LogMetrics"
        name          = "RouteTableChanges_WrongVal"
        value         = "2"
        default_value = "0"
      }
    ]
  }
}

resource "aws_cloudwatch_metric_alarm" "wrong_metric_value" {
  expect_failure = true
  attrs = {
    metric_name         = "RouteTableChanges_WrongVal"
    namespace           = "LogMetrics"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    threshold           = 1
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:route-table-changes-wrong-val"]
  }
}

resource "aws_sns_topic" "wrong_metric_value" {
  skip = true
  attrs = {
    name = "route-table-changes-wrong-val"
    arn  = "arn:aws:sns:us-east-1:123456789012:route-table-changes-wrong-val"
  }
}

resource "aws_sns_topic_subscription" "wrong_metric_value" {
  expect_failure = true
  attrs = {
    topic_arn = "arn:aws:sns:us-east-1:123456789012:route-table-changes-wrong-val"
    protocol  = "email"
    endpoint  = "admin@example.com"
  }
}

# FAILING - Metric filter default_value is "1" instead of "0"
resource "aws_cloudtrail" "wrong_metric_default_value" {
  attrs = {
    is_multi_region_trail        = true
    enable_logging               = true
    cloud_watch_logs_group_arn   = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-logs"
    cloud_watch_logs_role_arn    = "arn:aws:iam::123456789012:role/CloudTrailRole"
  }
}

resource "aws_cloudwatch_log_group" "wrong_metric_default_value" {
  skip = true
  attrs = {
    name = "cloudtrail-logs"
    arn  = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-logs"
  }
}

resource "aws_cloudwatch_log_metric_filter" "wrong_metric_default_value" {
  expect_failure = true
  attrs = {
    log_group_name = "cloudtrail-logs"
    pattern        = "{($.eventSource=ec2.amazonaws.com) && (($.eventName=CreateRoute) || ($.eventName=CreateRouteTable) || ($.eventName=ReplaceRoute) || ($.eventName=ReplaceRouteTableAssociation) || ($.eventName=DeleteRouteTable) || ($.eventName=DeleteRoute) || ($.eventName=DisassociateRouteTable))}"
    metric_transformation = [
      {
        namespace     = "LogMetrics"
        name          = "RouteTableChanges_WrongDefault"
        value         = "1"
        default_value = "1"
      }
    ]
  }
}

resource "aws_cloudwatch_metric_alarm" "wrong_metric_default_value" {
  expect_failure = true
  attrs = {
    metric_name         = "RouteTableChanges_WrongDefault"
    namespace           = "LogMetrics"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    threshold           = 1
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:route-table-changes-wrong-default"]
  }
}

resource "aws_sns_topic" "wrong_metric_default_value" {
  skip = true
  attrs = {
    name = "route-table-changes-wrong-default"
    arn  = "arn:aws:sns:us-east-1:123456789012:route-table-changes-wrong-default"
  }
}

resource "aws_sns_topic_subscription" "wrong_metric_default_value" {
  expect_failure = true
  attrs = {
    topic_arn = "arn:aws:sns:us-east-1:123456789012:route-table-changes-wrong-default"
    protocol  = "email"
    endpoint  = "admin@example.com"
  }
}

# FAILING - Alarm comparison operator is not GreaterThanOrEqualToThreshold
resource "aws_cloudtrail" "wrong_comparison_operator" {
  attrs = {
    is_multi_region_trail        = true
    enable_logging               = true
    cloud_watch_logs_group_arn   = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-logs"
    cloud_watch_logs_role_arn    = "arn:aws:iam::123456789012:role/CloudTrailRole"
  }
}

resource "aws_cloudwatch_log_group" "wrong_comparison_operator" {
  skip = true
  attrs = {
    name = "cloudtrail-logs"
    arn  = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-logs"
  }
}

resource "aws_cloudwatch_log_metric_filter" "wrong_comparison_operator" {
  attrs = {
    log_group_name = "cloudtrail-logs"
    pattern        = "{($.eventSource=ec2.amazonaws.com) && (($.eventName=CreateRoute) || ($.eventName=CreateRouteTable) || ($.eventName=ReplaceRoute) || ($.eventName=ReplaceRouteTableAssociation) || ($.eventName=DeleteRouteTable) || ($.eventName=DeleteRoute) || ($.eventName=DisassociateRouteTable))}"
    metric_transformation = [
      {
        namespace     = "LogMetrics"
        name          = "RouteTableChanges_WrongOp"
        value         = "1"
        default_value = "0"
      }
    ]
  }
}

resource "aws_cloudwatch_metric_alarm" "wrong_comparison_operator" {
  expect_failure = true
  attrs = {
    metric_name         = "RouteTableChanges_WrongOp"
    namespace           = "LogMetrics"
    comparison_operator = "LessThanThreshold"
    threshold           = 1
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:route-table-changes-wrong-op"]
  }
}

resource "aws_sns_topic" "wrong_comparison_operator" {
  skip = true
  attrs = {
    name = "route-table-changes-wrong-op"
    arn  = "arn:aws:sns:us-east-1:123456789012:route-table-changes-wrong-op"
  }
}

resource "aws_sns_topic_subscription" "wrong_comparison_operator" {
  expect_failure = true
  attrs = {
    topic_arn = "arn:aws:sns:us-east-1:123456789012:route-table-changes-wrong-op"
    protocol  = "email"
    endpoint  = "admin@example.com"
  }
}

# FAILING - Alarm threshold is 0 instead of 1
resource "aws_cloudtrail" "wrong_alarm_threshold" {
  attrs = {
    is_multi_region_trail        = true
    enable_logging               = true
    cloud_watch_logs_group_arn   = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-logs"
    cloud_watch_logs_role_arn    = "arn:aws:iam::123456789012:role/CloudTrailRole"
  }
}

resource "aws_cloudwatch_log_group" "wrong_alarm_threshold" {
  skip = true
  attrs = {
    name = "cloudtrail-logs"
    arn  = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-logs"
  }
}

resource "aws_cloudwatch_log_metric_filter" "wrong_alarm_threshold" {
  attrs = {
    log_group_name = "cloudtrail-logs"
    pattern        = "{($.eventSource=ec2.amazonaws.com) && (($.eventName=CreateRoute) || ($.eventName=CreateRouteTable) || ($.eventName=ReplaceRoute) || ($.eventName=ReplaceRouteTableAssociation) || ($.eventName=DeleteRouteTable) || ($.eventName=DeleteRoute) || ($.eventName=DisassociateRouteTable))}"
    metric_transformation = [
      {
        namespace     = "LogMetrics"
        name          = "RouteTableChanges_WrongThreshold"
        value         = "1"
        default_value = "0"
      }
    ]
  }
}

resource "aws_cloudwatch_metric_alarm" "wrong_alarm_threshold" {
  expect_failure = true
  attrs = {
    metric_name         = "RouteTableChanges_WrongThreshold"
    namespace           = "LogMetrics"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    threshold           = 0
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:route-table-changes-wrong-threshold"]
  }
}

resource "aws_sns_topic" "wrong_alarm_threshold" {
  skip = true
  attrs = {
    name = "route-table-changes-wrong-threshold"
    arn  = "arn:aws:sns:us-east-1:123456789012:route-table-changes-wrong-threshold"
  }
}

resource "aws_sns_topic_subscription" "wrong_alarm_threshold" {
  expect_failure = true
  attrs = {
    topic_arn = "arn:aws:sns:us-east-1:123456789012:route-table-changes-wrong-threshold"
    protocol  = "email"
    endpoint  = "admin@example.com"
  }
}

# FAILING - Alarm has no SNS topic in alarm_actions
resource "aws_cloudtrail" "no_sns_topic_in_alarm" {
  attrs = {
    is_multi_region_trail        = true
    enable_logging               = true
    cloud_watch_logs_group_arn   = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-logs"
    cloud_watch_logs_role_arn    = "arn:aws:iam::123456789012:role/CloudTrailRole"
  }
}

resource "aws_cloudwatch_log_group" "no_sns_topic_in_alarm" {
  skip = true
  attrs = {
    name = "cloudtrail-logs"
    arn  = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-logs"
  }
}

resource "aws_cloudwatch_log_metric_filter" "no_sns_topic_in_alarm" {
  attrs = {
    log_group_name = "cloudtrail-logs"
    pattern        = "{($.eventSource=ec2.amazonaws.com) && (($.eventName=CreateRoute) || ($.eventName=CreateRouteTable) || ($.eventName=ReplaceRoute) || ($.eventName=ReplaceRouteTableAssociation) || ($.eventName=DeleteRouteTable) || ($.eventName=DeleteRoute) || ($.eventName=DisassociateRouteTable))}"
    metric_transformation = [
      {
        namespace     = "LogMetrics"
        name          = "RouteTableChanges_NoSns"
        value         = "1"
        default_value = "0"
      }
    ]
  }
}

resource "aws_cloudwatch_metric_alarm" "no_sns_topic_in_alarm" {
  expect_failure = true
  attrs = {
    metric_name         = "RouteTableChanges_NoSns"
    namespace           = "LogMetrics"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    threshold           = 1
    alarm_actions       = []
  }
}

resource "aws_sns_topic" "no_sns_topic_in_alarm" {
  skip = true
  attrs = {
    name = "route-table-changes-no-sns"
    arn  = "arn:aws:sns:us-east-1:123456789012:route-table-changes-no-sns"
  }
}

resource "aws_sns_topic_subscription" "no_sns_topic_in_alarm" {
  expect_failure = true
  attrs = {
    topic_arn = "arn:aws:sns:us-east-1:123456789012:route-table-changes-no-sns"
    protocol  = "email"
    endpoint  = "admin@example.com"
  }
}

# FAILING - SNS topic has no subscriptions; subscription references a topic not in the valid chain
resource "aws_cloudtrail" "sns_no_subscriptions" {
  attrs = {
    is_multi_region_trail        = true
    enable_logging               = true
    cloud_watch_logs_group_arn   = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-logs"
    cloud_watch_logs_role_arn    = "arn:aws:iam::123456789012:role/CloudTrailRole"
  }
}

resource "aws_cloudwatch_log_group" "sns_no_subscriptions" {
  skip = true
  attrs = {
    name = "cloudtrail-logs"
    arn  = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-logs"
  }
}

resource "aws_cloudwatch_log_metric_filter" "sns_no_subscriptions" {
  attrs = {
    log_group_name = "cloudtrail-logs"
    pattern        = "{($.eventSource=ec2.amazonaws.com) && (($.eventName=CreateRoute) || ($.eventName=CreateRouteTable) || ($.eventName=ReplaceRoute) || ($.eventName=ReplaceRouteTableAssociation) || ($.eventName=DeleteRouteTable) || ($.eventName=DeleteRoute) || ($.eventName=DisassociateRouteTable))}"
    metric_transformation = [
      {
        namespace     = "LogMetrics"
        name          = "RouteTableChanges_NoSubs"
        value         = "1"
        default_value = "0"
      }
    ]
  }
}

resource "aws_cloudwatch_metric_alarm" "sns_no_subscriptions" {
  attrs = {
    metric_name         = "RouteTableChanges_NoSubs"
    namespace           = "LogMetrics"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    threshold           = 1
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:route-table-changes-no-subs"]
  }
}

resource "aws_sns_topic" "sns_no_subscriptions" {
  skip = true
  attrs = {
    name = "route-table-changes-no-subs"
    arn  = "arn:aws:sns:us-east-1:123456789012:route-table-changes-no-subs"
  }
}

# Subscription references an unrelated topic not connected to any valid alarm chain
resource "aws_sns_topic_subscription" "sns_no_subscriptions" {
  expect_failure = true
  attrs = {
    topic_arn = "arn:aws:sns:us-east-1:123456789012:unrelated-topic"
    protocol  = "email"
    endpoint  = "admin@example.com"
  }
}
