# Copyright IBM Corp. 2026

policytest {
  targets = ["cloudwatch-unauthorized-api-calls-alarm.policy.hcl"]
}

# ──────────────────────────────────────────────────────────────
# PASS cases
# ──────────────────────────────────────────────────────────────

# Test 1: PASS - compliant metric filter with correct pattern
resource "aws_cloudwatch_log_metric_filter" "pass_unauthorized_api_filter" {
  attrs = {
    name           = "unauthorized-api-calls"
    pattern        = "{($.errorCode=\"*UnauthorizedOperation\") || ($.errorCode=\"AccessDenied*\")}"
    log_group_name = "cloudtrail-events"
    metric_transformation = [{
      name      = "UnauthorizedAPICalls"
      namespace = "SecurityMetrics"
      value     = "1"
    }]
  }
}

# Test 2: PASS - compliant alarm referencing the correct metric
resource "aws_cloudwatch_metric_alarm" "pass_unauthorized_api_alarm" {
  attrs = {
    alarm_name          = "unauthorized-api-calls-alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 1
    metric_name         = "UnauthorizedAPICalls"
    namespace           = "SecurityMetrics"
    period              = 300
    statistic           = "Sum"
    threshold           = 1
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:security-alerts"]
  }
}

# Test 3: PASS - compliant SNS subscription linked to compliant alarm
resource "aws_sns_topic_subscription" "pass_unauthorized_api_subscription" {
  attrs = {
    topic_arn = "arn:aws:sns:us-east-1:123456789012:security-alerts"
    protocol  = "email"
    endpoint  = "security@example.com"
  }
}

# ──────────────────────────────────────────────────────────────
# FAIL cases
# ──────────────────────────────────────────────────────────────

# Test 4: FAIL - filter pattern missing UnauthorizedOperation
resource "aws_cloudwatch_log_metric_filter" "fail_missing_unauthorized_operation" {
  expect_failure = true
  attrs = {
    name           = "wrong-pattern"
    pattern        = "{($.errorCode=\"AccessDenied*\")}"
    log_group_name = "cloudtrail-events"
    metric_transformation = [{
      name      = "WrongMetric"
      namespace = "SecurityMetrics"
      value     = "1"
    }]
  }
}

# Test 5: FAIL - filter pattern missing AccessDenied
resource "aws_cloudwatch_log_metric_filter" "fail_missing_access_denied" {
  expect_failure = true
  attrs = {
    name           = "missing-access-denied"
    pattern        = "{($.errorCode=\"*UnauthorizedOperation\")}"
    log_group_name = "cloudtrail-events"
    metric_transformation = [{
      name      = "MissingMetric"
      namespace = "SecurityMetrics"
      value     = "1"
    }]
  }
}

# Test 6: FAIL - alarm references wrong metric name (not linked to unauthorized-API filter)
resource "aws_cloudwatch_metric_alarm" "fail_wrong_metric_name" {
  expect_failure = true
  attrs = {
    alarm_name          = "wrong-metric-alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 1
    metric_name         = "SomeOtherMetric"
    namespace           = "SecurityMetrics"
    period              = 300
    statistic           = "Sum"
    threshold           = 1
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:security-alerts"]
  }
}

# Test 7: FAIL - alarm has no alarm_actions
resource "aws_cloudwatch_metric_alarm" "fail_no_alarm_actions" {
  expect_failure = true
  attrs = {
    alarm_name          = "no-actions-alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 1
    metric_name         = "UnauthorizedAPICalls"
    namespace           = "SecurityMetrics"
    period              = 300
    statistic           = "Sum"
    threshold           = 1
    alarm_actions       = []
  }
}

# Test 8: FAIL - wrong comparison operator
resource "aws_cloudwatch_metric_alarm" "fail_wrong_comparison_operator" {
  expect_failure = true
  attrs = {
    alarm_name          = "wrong-comparison-alarm"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods  = 1
    metric_name         = "UnauthorizedAPICalls"
    namespace           = "SecurityMetrics"
    period              = 300
    statistic           = "Sum"
    threshold           = 1
    alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:security-alerts"]
  }
}

# Test 9: FAIL - SNS subscription not linked to any compliant alarm
resource "aws_sns_topic_subscription" "fail_unlinked_subscription" {
  expect_failure = true
  attrs = {
    topic_arn = "arn:aws:sns:us-east-1:123456789012:unrelated-topic"
    protocol  = "email"
    endpoint  = "other@example.com"
  }
}
