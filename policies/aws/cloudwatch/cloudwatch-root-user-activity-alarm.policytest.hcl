# Copyright IBM Corp. 2026

policytest {
  targets = ["cloudwatch-root-user-activity-alarm.policy.hcl"]
}

resource "aws_cloudwatch_log_metric_filter" "pass_root_filter" {
  attrs = {
    name           = "root-user-activity"
    pattern        = "{ $.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\" }"
    log_group_name = "cloudtrail-events"
    metric_transformation = [{
      name      = "RootUserActivity"
      namespace = "SecurityMetrics"
      value     = "1"
    }]
  }
}

resource "aws_cloudwatch_log_metric_filter" "fail_non_root_filter" {
  expect_failure = true
  attrs = {
    name           = "console-sign-in"
    pattern        = "{ $.eventName = \"ConsoleLogin\" }"
    log_group_name = "cloudtrail-events"
    metric_transformation = [{
      name      = "ConsoleSignIn"
      namespace = "SecurityMetrics"
      value     = "1"
    }]
  }
}

resource "aws_cloudwatch_metric_alarm" "pass_lower_threshold" {
  attrs = {
    alarm_name          = "root-user-activity-lower"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 1
    metric_name         = "RootUserActivity"
    namespace           = "SecurityMetrics"
    period              = 300
    statistic           = "Sum"
    threshold           = 0
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:root-user-alerts"]
  }
}

resource "aws_cloudwatch_metric_alarm" "pass_upper_threshold" {
  attrs = {
    alarm_name          = "root-user-activity-upper"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 1
    metric_name         = "RootUserActivity"
    namespace           = "SecurityMetrics"
    period              = 300
    statistic           = "Sum"
    threshold           = 1
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:root-user-alerts"]
  }
}

resource "aws_cloudwatch_metric_alarm" "fail_missing_metric_name" {
  expect_failure = true
  attrs = {
    alarm_name          = "missing-metric-name"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 1
    namespace           = "SecurityMetrics"
    period              = 300
    statistic           = "Sum"
    threshold           = 0
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:root-user-alerts"]
  }
}

resource "aws_cloudwatch_metric_alarm" "fail_unlinked_metric" {
  expect_failure = true
  attrs = {
    alarm_name          = "unlinked-metric"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 1
    metric_name         = "OtherMetric"
    namespace           = "SecurityMetrics"
    period              = 300
    statistic           = "Sum"
    threshold           = 0
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:root-user-alerts"]
  }
}

resource "aws_cloudwatch_metric_alarm" "fail_threshold_below_range" {
  expect_failure = true
  attrs = {
    alarm_name          = "threshold-below-range"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 1
    metric_name         = "RootUserActivity"
    namespace           = "SecurityMetrics"
    period              = 300
    statistic           = "Sum"
    threshold           = -1
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:root-user-alerts"]
  }
}

resource "aws_cloudwatch_metric_alarm" "fail_threshold_above_range" {
  expect_failure = true
  attrs = {
    alarm_name          = "threshold-above-range"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 1
    metric_name         = "RootUserActivity"
    namespace           = "SecurityMetrics"
    period              = 300
    statistic           = "Sum"
    threshold           = 2
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:root-user-alerts"]
  }
}

resource "aws_cloudwatch_metric_alarm" "fail_wrong_comparison" {
  expect_failure = true
  attrs = {
    alarm_name          = "wrong-comparison"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods  = 1
    metric_name         = "RootUserActivity"
    namespace           = "SecurityMetrics"
    period              = 300
    statistic           = "Sum"
    threshold           = 0
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:root-user-alerts"]
  }
}

resource "aws_cloudwatch_metric_alarm" "fail_empty_actions" {
  expect_failure = true
  attrs = {
    alarm_name          = "empty-actions"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 1
    metric_name         = "RootUserActivity"
    namespace           = "SecurityMetrics"
    period              = 300
    statistic           = "Sum"
    threshold           = 0
    alarm_actions       = []
  }
}

resource "aws_cloudwatch_metric_alarm" "fail_null_actions" {
  expect_failure = true
  attrs = {
    alarm_name          = "null-actions"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 1
    metric_name         = "RootUserActivity"
    namespace           = "SecurityMetrics"
    period              = 300
    statistic           = "Sum"
    threshold           = 0
    alarm_actions       = null
  }
}

resource "aws_sns_topic_subscription" "pass_linked_subscription" {
  attrs = {
    topic_arn = "arn:aws:sns:us-east-1:123456789012:root-user-alerts"
    protocol  = "email"
    endpoint  = "security@example.com"
  }
}

resource "aws_sns_topic_subscription" "fail_unlinked_subscription" {
  expect_failure = true
  attrs = {
    topic_arn = "arn:aws:sns:us-east-1:123456789012:unrelated-alerts"
    protocol  = "email"
    endpoint  = "security@example.com"
  }
}

