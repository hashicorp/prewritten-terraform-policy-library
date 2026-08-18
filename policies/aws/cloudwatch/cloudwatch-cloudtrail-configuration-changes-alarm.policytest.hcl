# Copyright IBM Corp. 2026

policytest {
  targets = ["cloudwatch-cloudtrail-configuration-changes-alarm.policy.hcl"]
}

# ──────────────────────────────────────────────────────────────
# PASS cases
# ──────────────────────────────────────────────────────────────

# Test 1: PASS - compliant metric filter with correct pattern
resource "aws_cloudwatch_log_metric_filter" "pass_cloudtrail_changes_filter" {
  attrs = {
    name           = "cloudtrail-config-changes"
    pattern        = "{($.eventName=CreateTrail) || ($.eventName=UpdateTrail) || ($.eventName=DeleteTrail) || ($.eventName=StartLogging) || ($.eventName=StopLogging)}"
    log_group_name = "cloudtrail-events"
    metric_transformation = [{
      name      = "CloudTrailChanges"
      namespace = "SecurityMetrics"
      value     = "1"
    }]
  }
}

# Test 2: PASS - compliant alarm referencing the correct metric
resource "aws_cloudwatch_metric_alarm" "pass_cloudtrail_changes_alarm" {
  attrs = {
    alarm_name          = "cloudtrail-changes-alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 1
    metric_name         = "CloudTrailChanges"
    namespace           = "SecurityMetrics"
    period              = 300
    statistic           = "Sum"
    threshold           = 1
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:security-alerts"]
  }
}

# Test 3: PASS - compliant SNS subscription linked to compliant alarm
resource "aws_sns_topic_subscription" "pass_cloudtrail_changes_subscription" {
  attrs = {
    topic_arn = "arn:aws:sns:us-east-1:123456789012:security-alerts"
    protocol  = "email"
    endpoint  = "security@example.com"
  }
}

# ──────────────────────────────────────────────────────────────
# FAIL cases
# ──────────────────────────────────────────────────────────────

# Test 4: FAIL - filter pattern missing CreateTrail
resource "aws_cloudwatch_log_metric_filter" "fail_missing_create_trail" {
  expect_failure = true
  attrs = {
    name           = "incomplete-pattern"
    pattern        = "{($.eventName=UpdateTrail) || ($.eventName=DeleteTrail) || ($.eventName=StopLogging)}"
    log_group_name = "cloudtrail-events"
    metric_transformation = [{
      name      = "IncompleteMetric"
      namespace = "SecurityMetrics"
      value     = "1"
    }]
  }
}

# Test 5: FAIL - filter pattern missing StopLogging
resource "aws_cloudwatch_log_metric_filter" "fail_missing_stop_logging" {
  expect_failure = true
  attrs = {
    name           = "missing-stop-logging"
    pattern        = "{($.eventName=CreateTrail) || ($.eventName=UpdateTrail) || ($.eventName=DeleteTrail)}"
    log_group_name = "cloudtrail-events"
    metric_transformation = [{
      name      = "MissingStopLogging"
      namespace = "SecurityMetrics"
      value     = "1"
    }]
  }
}

# Test 6: FAIL - alarm references unrelated metric
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

# Test 7: FAIL - alarm missing alarm_actions
resource "aws_cloudwatch_metric_alarm" "fail_no_alarm_actions" {
  expect_failure = true
  attrs = {
    alarm_name          = "no-actions-alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 1
    metric_name         = "CloudTrailChanges"
    namespace           = "SecurityMetrics"
    period              = 300
    statistic           = "Sum"
    threshold           = 1
    alarm_actions       = []
  }
}

# Test 8: FAIL - SNS subscription not linked to any compliant alarm
resource "aws_sns_topic_subscription" "fail_unlinked_subscription" {
  expect_failure = true
  attrs = {
    topic_arn = "arn:aws:sns:us-east-1:123456789012:unrelated-topic"
    protocol  = "email"
    endpoint  = "other@example.com"
  }
}
