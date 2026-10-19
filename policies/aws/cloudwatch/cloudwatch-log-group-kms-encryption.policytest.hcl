# Copyright IBM Corp. 2026

policytest {
  targets = ["cloudwatch-log-group-kms-encryption.policy.hcl"]
}

# PASS: any kms key
resource "aws_cloudwatch_log_group" "pass_any_kms_key" {
  attrs = {
    name              = "app-logs"
    retention_in_days = 30
    kms_key_id        = "arn:aws:kms:us-east-1:123456789012:key/1234abcd-12ab-34cd-56ef-1234567890ab"
  }
}

# FAIL: kms_key_id attribute is entirely omitted (missing attribute scenario)
resource "aws_cloudwatch_log_group" "fail_kms_key_id_missing" {
  expect_failure = true
  attrs = {
    name              = "app-logs-missing-kms"
    retention_in_days = 30
  }
}

# FAIL: kms key id null
resource "aws_cloudwatch_log_group" "fail_kms_key_id_null" {
  expect_failure = true
  attrs = {
    name              = "app-logs-null-kms"
    retention_in_days = 30
    kms_key_id        = null
  }
}

# FAIL: kms_key_id is set to an empty string (configured but empty)
resource "aws_cloudwatch_log_group" "fail_kms_key_id_empty_string" {
  expect_failure = true
  attrs = {
    name              = "app-logs-empty-kms"
    retention_in_days = 30
    kms_key_id        = ""
  }
}

# PASS: matching required key
resource "aws_cloudwatch_log_group" "pass_matching_required_key_f2" {
  attrs = {
    name              = "secure-app-logs"
    retention_in_days = 90
    kms_key_id        = "arn:aws:kms:us-east-1:123456789012:key/required-key-aaaa-bbbb-cccc"
  }
}

# FAIL: kms_key_id is omitted entirely while a specific key is required
resource "aws_cloudwatch_log_group" "fail_missing_key_with_required_f2" {
  expect_failure = true
  attrs = {
    name              = "secure-app-logs-no-key"
    retention_in_days = 90
  }
}
