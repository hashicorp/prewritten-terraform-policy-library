# Copyright IBM Corp. 2026

# Separate file: assumes inputs.kms_key_id is overridden to a specific KMS key ARN
# (see testcase_gen.md 4.2 case 1 — a distinct `inputs {}` value from the default-input
# file). This verifies behaviour when a specific required KMS key is configured.

policytest {
  targets = ["cloudwatch-log-group-kms-encryption.policy.hcl"]
}

inputs {
  cloudwatch-log-group-kms-encryption-kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/required-key-aaaa-bbbb-cccc"
}

# PASS: kms_key_id exactly matches the required key
resource "aws_cloudwatch_log_group" "pass_matching_required_key" {
  attrs = {
    name              = "secure-app-logs"
    retention_in_days = 90
    kms_key_id        = "arn:aws:kms:us-east-1:123456789012:key/required-key-aaaa-bbbb-cccc"
  }
}

# FAIL: kms_key_id is set but does not match the required key
resource "aws_cloudwatch_log_group" "fail_different_kms_key" {
  expect_failure = true
  attrs = {
    name              = "secure-app-logs-wrong-key"
    retention_in_days = 90
    kms_key_id        = "arn:aws:kms:us-east-1:123456789012:key/other-key-dddd-eeee-ffff"
  }
}

# FAIL: kms_key_id is omitted entirely while a specific key is required
resource "aws_cloudwatch_log_group" "fail_missing_key_with_required" {
  expect_failure = true
  attrs = {
    name              = "secure-app-logs-no-key"
    retention_in_days = 90
  }
}
