# Copyright IBM Corp. 2026

policytest {
  targets = ["cloudwatch-log-group-kms-encryption.policy.hcl"]
}

# Default inputs file: no inputs {} block, so input.kms_key_id uses its policy
# default of "" (no specific KMS key required — any KMS key is acceptable).

# PASS: kms_key_id is set to a non-empty value, no specific key required
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

# FAIL: kms_key_id is explicitly null — policy's two-step normalization treats
# null the same as "" (not configured), so this is a non-compliance case.
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
