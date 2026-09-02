# Copyright IBM Corp. 2026

policytest {
    targets = [
        "rds-pg-event-notifications-configured.policy.hcl"
    ]
}

# Test 1: PASS - db-parameter-group subscription with the required category, enabled explicitly
resource "aws_db_event_subscription" "pass_required_category_enabled" {
  attrs = {
    name             = "rds-pg-events"
    source_type      = "db-parameter-group"
    event_categories = ["configuration change"]
    enabled          = true
    sns_topic        = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 2: PASS - db-parameter-group subscription with required category, enabled omitted (defaults to true)
resource "aws_db_event_subscription" "pass_required_category_default_enabled" {
  attrs = {
    name             = "rds-pg-events"
    source_type      = "db-parameter-group"
    event_categories = ["configuration change"]
    sns_topic        = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 3: PASS - db-parameter-group subscription with required category plus extra categories
resource "aws_db_event_subscription" "pass_required_plus_extra_categories" {
  attrs = {
    name             = "rds-pg-events"
    source_type      = "db-parameter-group"
    event_categories = ["configuration change", "maintenance", "failure"]
    enabled          = true
    sns_topic        = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 4: PASS - db-parameter-group subscription with no event_categories attribute (defaults to [], condition passes)
resource "aws_db_event_subscription" "pass_no_event_categories_attr" {
  attrs = {
    name        = "rds-pg-events"
    source_type = "db-parameter-group"
    enabled     = true
    sns_topic   = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 5: FAIL - db-parameter-group subscription with categories that do not include 'configuration change'
resource "aws_db_event_subscription" "fail_missing_config_change" {
  expect_failure = true
  attrs = {
    name             = "rds-pg-events"
    source_type      = "db-parameter-group"
    event_categories = ["maintenance", "failure"]
    enabled          = true
    sns_topic        = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 6: FAIL - db-parameter-group subscription with required category but disabled
resource "aws_db_event_subscription" "fail_disabled_subscription" {
  expect_failure = true
  attrs = {
    name             = "rds-pg-events"
    source_type      = "db-parameter-group"
    event_categories = ["configuration change"]
    enabled          = false
    sns_topic        = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 7: FAIL - db-parameter-group subscription, non-empty categories but missing 'configuration change', disabled
resource "aws_db_event_subscription" "fail_wrong_categories_disabled" {
  expect_failure = true
  attrs = {
    name             = "rds-pg-events"
    source_type      = "db-parameter-group"
    event_categories = ["maintenance"]
    enabled          = false
    sns_topic        = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 8: PASS - source_type absent (empty string) with required category and enabled
resource "aws_db_event_subscription" "pass_no_source_type_with_required_category" {
  attrs = {
    name             = "rds-all-events"
    event_categories = ["configuration change"]
    enabled          = true
    sns_topic        = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 9: FAIL - source_type absent (empty string), categories present but missing 'configuration change'
resource "aws_db_event_subscription" "fail_no_source_type_missing_config_change" {
  expect_failure = true
  attrs = {
    name             = "rds-all-events"
    event_categories = ["maintenance", "failure"]
    enabled          = true
    sns_topic        = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 10: FAIL - source_type absent (empty string), subscription disabled
resource "aws_db_event_subscription" "fail_no_source_type_disabled" {
  expect_failure = true
  attrs = {
    name             = "rds-all-events"
    event_categories = ["configuration change"]
    enabled          = false
    sns_topic        = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 11: PASS - source_type absent (empty string), no event_categories (defaults to [], condition passes)
resource "aws_db_event_subscription" "pass_no_source_type_no_categories" {
  attrs = {
    name      = "rds-all-events"
    enabled   = true
    sns_topic = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 12: PASS - source_type is db-instance (filtered out, not evaluated)
resource "aws_db_event_subscription" "pass_db_instance_filtered_out" {
  attrs = {
    name             = "rds-instance-events"
    source_type      = "db-instance"
    event_categories = ["maintenance", "failure"]
    enabled          = false
    sns_topic        = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}
