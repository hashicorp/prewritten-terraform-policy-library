# Copyright IBM Corp. 2026

policytest {
    targets = [
        "rds-cluster-event-notifications-configured.policy.hcl"
    ]
}

# Test 1: PASS - db-cluster subscription with both required categories, enabled explicitly
resource "aws_db_event_subscription" "pass_with_both_categories_enabled" {
  attrs = {
    source_type      = "db-cluster"
    event_categories = ["maintenance", "failure"]
    enabled          = true
    sns_topic        = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 2: PASS - db-cluster subscription with both required categories, enabled omitted (defaults to true)
resource "aws_db_event_subscription" "pass_with_both_categories_default_enabled" {
  attrs = {
    source_type      = "db-cluster"
    event_categories = ["maintenance", "failure"]
    sns_topic        = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 3: PASS - db-cluster subscription with extra categories beyond the two required ones
resource "aws_db_event_subscription" "pass_with_extra_categories" {
  attrs = {
    source_type      = "db-cluster"
    event_categories = ["maintenance", "failure", "notification", "configuration change"]
    enabled          = true
    sns_topic        = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 4: FAIL - db-cluster subscription with only maintenance category (missing failure)
resource "aws_db_event_subscription" "fail_missing_failure_category" {
  expect_failure = true
  attrs = {
    source_type      = "db-cluster"
    event_categories = ["maintenance"]
    enabled          = true
    sns_topic        = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 5: FAIL - db-cluster subscription with only failure category (missing maintenance)
resource "aws_db_event_subscription" "fail_missing_maintenance_category" {
  expect_failure = true
  attrs = {
    source_type      = "db-cluster"
    event_categories = ["failure"]
    enabled          = true
    sns_topic        = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 6: FAIL - db-cluster subscription with neither required category
resource "aws_db_event_subscription" "fail_missing_both_categories" {
  expect_failure = true
  attrs = {
    source_type      = "db-cluster"
    event_categories = ["notification", "configuration change"]
    enabled          = true
    sns_topic        = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 7: FAIL - db-cluster subscription with both required categories but disabled
resource "aws_db_event_subscription" "fail_disabled_subscription" {
  expect_failure = true
  attrs = {
    source_type      = "db-cluster"
    event_categories = ["maintenance", "failure"]
    enabled          = false
    sns_topic        = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 8: PASS - db-cluster subscription with no event_categories attribute (defaults to [], condition passes)
resource "aws_db_event_subscription" "pass_no_event_categories_attr" {
  attrs = {
    source_type = "db-cluster"
    enabled     = true
    sns_topic   = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 9: PASS - source_type absent (empty string) with both required categories and enabled
resource "aws_db_event_subscription" "pass_no_source_type_with_required_categories" {
  attrs = {
    event_categories = ["maintenance", "failure"]
    enabled          = true
    sns_topic        = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 10: FAIL - source_type absent (empty string), only maintenance category present (missing failure)
resource "aws_db_event_subscription" "fail_no_source_type_missing_failure" {
  expect_failure = true
  attrs = {
    event_categories = ["maintenance"]
    enabled          = true
    sns_topic        = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 11: FAIL - source_type absent (empty string), subscription disabled
resource "aws_db_event_subscription" "fail_no_source_type_disabled" {
  expect_failure = true
  attrs = {
    event_categories = ["maintenance", "failure"]
    enabled          = false
    sns_topic        = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 12: PASS - source_type absent (empty string), no event_categories (defaults to [], condition passes)
resource "aws_db_event_subscription" "pass_no_source_type_no_categories" {
  attrs = {
    enabled   = true
    sns_topic = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}

# Test 13: PASS - source_type is db-instance (filtered out, not evaluated)
resource "aws_db_event_subscription" "pass_db_instance_filtered_out" {
  attrs = {
    source_type      = "db-instance"
    event_categories = ["notification"]
    enabled          = false
    sns_topic        = "arn:aws:sns:us-east-1:123456789012:rds-events"
  }
}
