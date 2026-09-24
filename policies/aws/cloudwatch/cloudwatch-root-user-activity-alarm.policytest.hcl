# Copyright IBM Corp. 2026

policytest {
  targets = ["cloudwatch-root-user-activity-alarm.policy.hcl"]
}

# ──────────────────────────────────────────────────────────────
# PASS cases
# ──────────────────────────────────────────────────────────────

# Declared SNS topic that backs the compliant alarm
resource "aws_sns_topic" "pass_root_user_activity_topic" {
  attrs = {
    name = "root-user-alerts"
    arn  = "arn:aws:sns:us-east-1:123456789012:root-user-alerts"
  }
}

# PASS - compliant metric filter: all terms, namespace, value=1, default_value=0
resource "aws_cloudwatch_log_metric_filter" "pass_root_filter" {
  attrs = {
    name           = "root-user-activity"
    pattern        = "{ $.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\" }"
    log_group_name = "cloudtrail-events"
    metric_transformation = [{
      name          = "RootUserActivity"
      namespace     = "SecurityMetrics"
      value         = "1"
      default_value = "0"
    }]
  }
}

# PASS - compliant alarm referencing correct metric and namespace
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

# PASS - compliant SNS subscription backed by declared topic and linked to compliant alarm
resource "aws_sns_topic_subscription" "pass_linked_subscription" {
  attrs = {
    topic_arn = "arn:aws:sns:us-east-1:123456789012:root-user-alerts"
    protocol  = "email"
    endpoint  = "security@example.com"
  }
}

# ──────────────────────────────────────────────────────────────
# FAIL cases — metric filter
# ──────────────────────────────────────────────────────────────

# FAIL - pattern missing root user terms
resource "aws_cloudwatch_log_metric_filter" "fail_non_root_filter" {
  expect_failure = true
  attrs = {
    name           = "console-sign-in"
    pattern        = "{ $.eventName = \"ConsoleLogin\" }"
    log_group_name = "cloudtrail-events"
    metric_transformation = [{
      name          = "ConsoleSignIn"
      namespace     = "SecurityMetrics"
      value         = "1"
      default_value = "0"
    }]
  }
}

# FAIL - filter missing default_value = "0"
resource "aws_cloudwatch_log_metric_filter" "fail_missing_default_value" {
  expect_failure = true
  attrs = {
    name           = "root-user-no-dv"
    pattern        = "{ $.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\" }"
    log_group_name = "cloudtrail-events"
    metric_transformation = [{
      name      = "RootUserActivityNoDV"
      namespace = "SecurityMetrics"
      value     = "1"
    }]
  }
}

# ──────────────────────────────────────────────────────────────
# FAIL cases — metric alarm
# ──────────────────────────────────────────────────────────────

# FAIL - threshold = 0
resource "aws_cloudwatch_metric_alarm" "pass_lower_threshold" {
  expect_failure = true
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

# FAIL - alarm references unrelated metric
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
    threshold           = 1
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:root-user-alerts"]
  }
}

# FAIL - alarm uses correct metric name but wrong namespace
resource "aws_cloudwatch_metric_alarm" "fail_wrong_namespace" {
  expect_failure = true
  attrs = {
    alarm_name          = "wrong-namespace-alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 1
    metric_name         = "RootUserActivity"
    namespace           = "WrongNamespace"
    period              = 300
    statistic           = "Sum"
    threshold           = 1
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:root-user-alerts"]
  }
}

# FAIL - threshold too high
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

# FAIL - wrong comparison operator
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
    threshold           = 1
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:root-user-alerts"]
  }
}

# FAIL - empty alarm_actions
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
    threshold           = 1
    alarm_actions       = []
  }
}

# ──────────────────────────────────────────────────────────────
# FAIL cases — SNS subscription
# ──────────────────────────────────────────────────────────────

# FAIL - subscription references undeclared topic (no aws_sns_topic resource)
resource "aws_sns_topic_subscription" "fail_undeclared_topic" {
  expect_failure = true
  attrs = {
    topic_arn = "arn:aws:sns:us-east-1:123456789012:undeclared-topic"
    protocol  = "email"
    endpoint  = "other@example.com"
  }
}

# FAIL - subscription topic not linked to any compliant alarm
resource "aws_sns_topic_subscription" "fail_unlinked_subscription" {
  expect_failure = true
  attrs = {
    topic_arn = "arn:aws:sns:us-east-1:123456789012:unrelated-alerts"
    protocol  = "email"
    endpoint  = "security@example.com"
  }
}

# ──────────────────────────────────────────────────────────────
# CloudTrail trail tests
# ──────────────────────────────────────────────────────────────

# PASS - all 4 fields set correctly
resource "aws_cloudtrail" "pass_root_user_activity_trail" {
  attrs = {
    name                          = "root-user-activity-trail"
    s3_bucket_name                = "my-cloudtrail-bucket"
    cloud_watch_logs_group_arn    = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-events:*"
    cloud_watch_logs_role_arn     = "arn:aws:iam::123456789012:role/CloudTrailCloudWatchLogsRole"
    enable_logging                = true
    is_multi_region_trail         = true
    include_global_service_events = true
  }
}

# FAIL - missing cloud_watch_logs_group_arn
resource "aws_cloudtrail" "fail_no_cloudwatch_logs" {
  expect_failure = true
  attrs = {
    name                      = "no-cw-logs-trail"
    s3_bucket_name            = "my-cloudtrail-bucket"
    cloud_watch_logs_role_arn = "arn:aws:iam::123456789012:role/CloudTrailCloudWatchLogsRole"
    enable_logging            = true
    is_multi_region_trail     = true
  }
}

# FAIL - logging disabled
resource "aws_cloudtrail" "fail_logging_disabled" {
  expect_failure = true
  attrs = {
    name                       = "logging-disabled-trail"
    s3_bucket_name             = "my-cloudtrail-bucket"
    cloud_watch_logs_group_arn = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-events:*"
    cloud_watch_logs_role_arn  = "arn:aws:iam::123456789012:role/CloudTrailCloudWatchLogsRole"
    enable_logging             = false
    is_multi_region_trail      = true
  }
}

# FAIL - missing cloud_watch_logs_role_arn
resource "aws_cloudtrail" "fail_no_cloudwatch_logs_role" {
  expect_failure = true
  attrs = {
    name                       = "no-role-trail"
    s3_bucket_name             = "my-cloudtrail-bucket"
    cloud_watch_logs_group_arn = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-events:*"
    enable_logging             = true
    is_multi_region_trail      = true
  }
}

# FAIL - single-region trail
resource "aws_cloudtrail" "fail_single_region_trail" {
  expect_failure = true
  attrs = {
    name                       = "single-region-trail"
    s3_bucket_name             = "my-cloudtrail-bucket"
    cloud_watch_logs_group_arn = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-events:*"
    cloud_watch_logs_role_arn  = "arn:aws:iam::123456789012:role/CloudTrailCloudWatchLogsRole"
    enable_logging             = true
    is_multi_region_trail      = false
  }
}
