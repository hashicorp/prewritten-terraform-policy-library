# Copyright IBM Corp. 2026

policytest {
  targets = ["cloudwatch-s3-bucket-policy-changes-alarm.policy.hcl"]
}

# ──────────────────────────────────────────────────────────────
# PASS cases
# ──────────────────────────────────────────────────────────────

# Test 1: PASS - declared SNS topic used by the compliant alarm
resource "aws_sns_topic" "pass_s3_policy_changes_topic" {
  attrs = {
    name = "security-alerts"
    arn  = "arn:aws:sns:us-east-1:123456789012:security-alerts"
  }
}

# Test 2: PASS - compliant metric filter with correct pattern, namespace, value, and default_value
resource "aws_cloudwatch_log_metric_filter" "pass_s3_policy_changes_filter" {
  attrs = {
    name           = "s3-bucket-policy-changes"
    pattern        = "{($.eventSource=s3.amazonaws.com) && (($.eventName=PutBucketAcl) || ($.eventName=PutBucketPolicy) || ($.eventName=PutBucketCors) || ($.eventName=PutBucketLifecycle) || ($.eventName=PutBucketReplication) || ($.eventName=DeleteBucketPolicy) || ($.eventName=DeleteBucketCors) || ($.eventName=DeleteBucketLifecycle) || ($.eventName=DeleteBucketReplication))}"
    log_group_name = "cloudtrail-events"
    metric_transformation = [{
      name          = "S3BucketPolicyChanges"
      namespace     = "SecurityMetrics"
      value         = "1"
      default_value = "0"
    }]
  }
}

# Test 3: PASS - compliant alarm referencing the correct metric and namespace
resource "aws_cloudwatch_metric_alarm" "pass_s3_policy_changes_alarm" {
  attrs = {
    alarm_name          = "s3-policy-changes-alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 1
    metric_name         = "S3BucketPolicyChanges"
    namespace           = "SecurityMetrics"
    period              = 300
    statistic           = "Sum"
    threshold           = 1
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:security-alerts"]
  }
}

# Test 4: PASS - compliant SNS subscription linked to compliant alarm and declared topic
resource "aws_sns_topic_subscription" "pass_s3_policy_changes_subscription" {
  attrs = {
    topic_arn = "arn:aws:sns:us-east-1:123456789012:security-alerts"
    protocol  = "email"
    endpoint  = "security@example.com"
  }
}

# ──────────────────────────────────────────────────────────────
# FAIL cases
# ──────────────────────────────────────────────────────────────

# Test 5: FAIL - filter pattern missing s3.amazonaws.com
resource "aws_cloudwatch_log_metric_filter" "fail_missing_s3_source" {
  expect_failure = true
  attrs = {
    name           = "missing-s3-source"
    pattern        = "{($.eventName=PutBucketPolicy) || ($.eventName=DeleteBucketPolicy)}"
    log_group_name = "cloudtrail-events"
    metric_transformation = [{
      name          = "MissingS3Source"
      namespace     = "SecurityMetrics"
      value         = "1"
      default_value = "0"
    }]
  }
}

# Test 6: FAIL - filter pattern missing DeleteBucketPolicy
resource "aws_cloudwatch_log_metric_filter" "fail_missing_delete_bucket_policy" {
  expect_failure = true
  attrs = {
    name           = "missing-delete-policy"
    pattern        = "{($.eventSource=s3.amazonaws.com) && ($.eventName=PutBucketPolicy)}"
    log_group_name = "cloudtrail-events"
    metric_transformation = [{
      name          = "MissingDelete"
      namespace     = "SecurityMetrics"
      value         = "1"
      default_value = "0"
    }]
  }
}

# Test 7: FAIL - filter missing default_value = "0"
resource "aws_cloudwatch_log_metric_filter" "fail_missing_default_value" {
  expect_failure = true
  attrs = {
    name           = "missing-default-value"
    pattern        = "{($.eventSource=s3.amazonaws.com) && (($.eventName=PutBucketAcl) || ($.eventName=PutBucketPolicy) || ($.eventName=PutBucketCors) || ($.eventName=PutBucketLifecycle) || ($.eventName=PutBucketReplication) || ($.eventName=DeleteBucketPolicy) || ($.eventName=DeleteBucketCors) || ($.eventName=DeleteBucketLifecycle) || ($.eventName=DeleteBucketReplication))}"
    log_group_name = "cloudtrail-events"
    metric_transformation = [{
      name      = "S3BucketPolicyChangesNoDefault"
      namespace = "SecurityMetrics"
      value     = "1"
    }]
  }
}

# Test 8: FAIL - alarm references unrelated metric
resource "aws_cloudwatch_metric_alarm" "fail_wrong_metric" {
  expect_failure = true
  attrs = {
    alarm_name          = "wrong-metric-alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 1
    metric_name         = "UnrelatedMetric"
    namespace           = "SecurityMetrics"
    period              = 300
    statistic           = "Sum"
    threshold           = 1
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:security-alerts"]
  }
}

# Test 9: FAIL - alarm uses wrong namespace for the metric
resource "aws_cloudwatch_metric_alarm" "fail_wrong_namespace" {
  expect_failure = true
  attrs = {
    alarm_name          = "wrong-namespace-alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 1
    metric_name         = "S3BucketPolicyChanges"
    namespace           = "WrongNamespace"
    period              = 300
    statistic           = "Sum"
    threshold           = 1
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:security-alerts"]
  }
}

# Test 10: FAIL - alarm with threshold 0
resource "aws_cloudwatch_metric_alarm" "fail_zero_threshold" {
  expect_failure = true
  attrs = {
    alarm_name          = "zero-threshold-alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 1
    metric_name         = "S3BucketPolicyChanges"
    namespace           = "SecurityMetrics"
    period              = 300
    statistic           = "Sum"
    threshold           = 0
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:security-alerts"]
  }
}

# Test 11: FAIL - alarm missing alarm_actions
resource "aws_cloudwatch_metric_alarm" "fail_no_alarm_actions" {
  expect_failure = true
  attrs = {
    alarm_name          = "no-actions-alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 1
    metric_name         = "S3BucketPolicyChanges"
    namespace           = "SecurityMetrics"
    period              = 300
    statistic           = "Sum"
    threshold           = 1
    alarm_actions       = []
  }
}

# Test 12: FAIL - SNS subscription references a topic that is not declared as aws_sns_topic
resource "aws_sns_topic_subscription" "fail_undeclared_topic" {
  expect_failure = true
  attrs = {
    topic_arn = "arn:aws:sns:us-east-1:123456789012:undeclared-topic"
    protocol  = "email"
    endpoint  = "other@example.com"
  }
}

# Test 13: FAIL - SNS subscription topic declared but not linked to any compliant alarm
resource "aws_sns_topic_subscription" "fail_unlinked_subscription" {
  expect_failure = true
  attrs = {
    topic_arn = "arn:aws:sns:us-east-1:123456789012:unrelated-topic"
    protocol  = "email"
    endpoint  = "other@example.com"
  }
}

# ──────────────────────────────────────────────────────────────
# CloudTrail trail tests
# ──────────────────────────────────────────────────────────────

# Test: PASS - trail with CloudWatch Logs integration and logging enabled
resource "aws_cloudtrail" "pass_s3_policy_changes_trail" {
  attrs = {
    name                          = "s3-policy-changes-trail"
    s3_bucket_name                = "my-cloudtrail-bucket"
    cloud_watch_logs_group_arn    = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-events:*"
    cloud_watch_logs_role_arn     = "arn:aws:iam::123456789012:role/CloudTrailCloudWatchLogsRole"
    enable_logging                = true
    is_multi_region_trail         = true
    include_global_service_events = true
  }
}

# Test: FAIL - trail missing cloud_watch_logs_group_arn
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

# Test: FAIL - trail with logging disabled
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

# Test: FAIL - trail missing cloud_watch_logs_role_arn
resource "aws_cloudtrail" "fail_no_cloudwatch_logs_role" {
  expect_failure = true
  attrs = {
    name                       = "no-cw-logs-role-trail"
    s3_bucket_name             = "my-cloudtrail-bucket"
    cloud_watch_logs_group_arn = "arn:aws:logs:us-east-1:123456789012:log-group:cloudtrail-events:*"
    enable_logging             = true
    is_multi_region_trail      = true
  }
}

# Test: FAIL - single-region trail (no full account coverage)
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
