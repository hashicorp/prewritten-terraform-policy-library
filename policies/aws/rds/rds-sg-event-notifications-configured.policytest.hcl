# Copyright IBM Corp. 2026

policytest {
    targets = [
        "rds-sg-event-notifications-configured.policy.hcl"
    ]
}

# Test 1: PASS - Subscription with both required categories and enabled
resource "aws_db_event_subscription" "pass_with_both_categories_enabled" {
  attrs = {
    source_type = "db-security-group"
    sns_topic = "arn:aws:sns:us-east-1:123456789012:rds-events"
    event_categories = ["configuration change", "failure"]
    enabled = true
  }
}

# Test 2: PASS - Subscription with both required categories and enabled not set (defaults to true)
resource "aws_db_event_subscription" "pass_with_both_categories_default_enabled" {
  attrs = {
    source_type = "db-security-group"
    sns_topic = "arn:aws:sns:us-east-1:123456789012:rds-events"
    event_categories = ["configuration change", "failure"]
  }
}

# Test 3: PASS - Subscription with all event categories including required ones
resource "aws_db_event_subscription" "pass_with_all_categories" {
  attrs = {
    source_type = "db-security-group"
    event_categories = ["configuration change", "failure", "availability", "backup"]
    enabled = true
    sns_topic = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 4: FAIL - Subscription with only failure category (missing configuration change)
resource "aws_db_event_subscription" "fail_missing_config_change_category" {
  expect_failure = true
  attrs = {
    source_type = "db-security-group"
    event_categories = ["failure"]
    enabled = true
    sns_topic = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 5: FAIL - Subscription with only configuration change category (missing failure)
resource "aws_db_event_subscription" "fail_missing_failure_category" {
  expect_failure = true
  attrs = {
    source_type = "db-security-group"
    event_categories = ["configuration change"]
    enabled = true
    sns_topic = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 6: PASS - Missing event categories
resource "aws_db_event_subscription" "pass_missing_both_categories" {
  attrs = {
    source_type = "db-security-group"
    enabled = true
    sns_topic = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 7: FAIL - Enabled set to false
resource "aws_db_event_subscription" "fail_disabled" {
  expect_failure = true
  attrs = {
    source_type = "db-security-group"
    event_categories = ["configuration change", "failure"]
    enabled = false
    sns_topic = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 8: FAIL - Wrong event categories
resource "aws_db_event_subscription" "fail_wrong_categories" {
  expect_failure = true
  attrs = {
    source_type = "db-security-group"
    event_categories = ["availability", "backup"]
    enabled = true
    sns_topic = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 9: PASS - No event_categories attribute set (empty list default), subscription is enabled
resource "aws_db_event_subscription" "pass_no_event_categories_attr" {
  attrs = {
    source_type = "db-security-group"
    enabled     = true
    sns_topic   = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 10: PASS - source_type absent (empty string) with both required categories and enabled
resource "aws_db_event_subscription" "pass_no_source_type_with_required_categories" {
  attrs = {
    event_categories = ["configuration change", "failure"]
    enabled          = true
    sns_topic        = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 11: FAIL - source_type absent (empty string), only one required category present
resource "aws_db_event_subscription" "fail_no_source_type_missing_failure" {
  expect_failure = true
  attrs = {
    event_categories = ["configuration change"]
    enabled          = true
    sns_topic        = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 12: FAIL - source_type absent (empty string), subscription disabled
resource "aws_db_event_subscription" "fail_no_source_type_disabled" {
  expect_failure = true
  attrs = {
    event_categories = ["configuration change", "failure"]
    enabled          = false
    sns_topic        = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 13: PASS - source_type is db-instance (filtered out, not evaluated)
resource "aws_db_event_subscription" "pass_db_instance_filtered_out" {
  attrs = {
    source_type      = "db-instance"
    event_categories = ["availability"]
    enabled          = false
  }
}