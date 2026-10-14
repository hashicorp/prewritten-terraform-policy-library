# Copyright IBM Corp. 2026

policytest {
  targets = ["s3-bucket-should-have-object-lock-enabled.policy.hcl"]
}

# PASS: Object Lock is enabled; no mode is required by default
resource "aws_s3_bucket" "pass_lock_enabled_without_mode" {
  attrs = {
    bucket              = "pass_lock_enabled_without_mode"
    object_lock_enabled = true
  }
}

# PASS: Object Lock is enabled with COMPLIANCE default retention
resource "aws_s3_bucket" "pass_compliance" {
  attrs = {
    bucket              = "pass_compliance"
    object_lock_enabled = true
  }
}

resource "aws_s3_bucket_object_lock_configuration" "pass_compliance" {
  skip = true
  attrs = {
    bucket = "pass_compliance"
    rule = [{
      default_retention = [{
        mode = "COMPLIANCE"
        days = 5
      }]
    }]
  }
}

# PASS: Object Lock is enabled with GOVERNANCE default retention
resource "aws_s3_bucket" "pass_governance" {
  attrs = {
    bucket              = "pass_governance"
    object_lock_enabled = true
  }
}

resource "aws_s3_bucket_object_lock_configuration" "pass_governance" {
  skip = true
  attrs = {
    bucket = "pass_governance"
    rule = [{
      default_retention = [{
        mode  = "GOVERNANCE"
        years = 1
      }]
    }]
  }
}

# PASS: Object Lock is enabled even when a retention mode is not configured
resource "aws_s3_bucket" "pass_without_retention_mode" {
  attrs = {
    bucket              = "pass_without_retention_mode"
    object_lock_enabled = true
  }
}

resource "aws_s3_bucket_object_lock_configuration" "other_bucket" {
  skip = true
  attrs = {
    bucket = "another_bucket"
    rule = [{
      default_retention = [{
        mode = "COMPLIANCE"
        days = 5
      }]
    }]
  }
}

# FAIL: Object Lock is disabled
resource "aws_s3_bucket" "fail_lock_disabled" {
  expect_failure = true
  attrs = {
    bucket              = "fail_lock_disabled"
    object_lock_enabled = false
  }
}

# FAIL: object_lock_enabled is absent
resource "aws_s3_bucket" "fail_lock_enabled_missing" {
  expect_failure = true
  attrs = {
    bucket = "fail_lock_enabled_missing"
  }
}
