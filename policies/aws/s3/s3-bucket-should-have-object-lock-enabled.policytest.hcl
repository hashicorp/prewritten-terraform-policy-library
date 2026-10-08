# Copyright IBM Corp. 2026

policytest {
  targets = ["s3-bucket-should-have-object-lock-enabled.policy.hcl"]
}

# ---- PASS: COMPLIANCE ----
resource "aws_s3_bucket" "pass_compliance" {
  attrs = {
    id     = "bucket-compliance"
    bucket = "bucket-compliance"
  }
}

resource "aws_s3_bucket_object_lock_configuration" "lock_compliance" {
  skip = true
  attrs = {
    bucket = "bucket-compliance"
    rule = [{
      default_retention = [{
        mode = "COMPLIANCE"
        days = 30
      }]
    }]
  }
}

# ---- PASS: GOVERNANCE ----
resource "aws_s3_bucket" "pass_governance" {
  attrs = {
    id     = "bucket-governance"
    bucket = "bucket-governance"
  }
}

resource "aws_s3_bucket_object_lock_configuration" "lock_governance" {
  skip = true
  attrs = {
    bucket = "bucket-governance"
    rule = [{
      default_retention = [{
        mode  = "GOVERNANCE"
        years = 1
      }]
    }]
  }
}

# ---- FAIL: no lock configuration at all ----
resource "aws_s3_bucket" "fail_no_lock_config" {
  expect_failure = true
  attrs = {
    id     = "bucket-no-lock"
    bucket = "bucket-no-lock"
  }
}

# ---- FAIL: configuration has no rule block ----
resource "aws_s3_bucket" "fail_no_rule" {
  expect_failure = true
  attrs = {
    id     = "bucket-no-rule"
    bucket = "bucket-no-rule"
  }
}

resource "aws_s3_bucket_object_lock_configuration" "lock_no_rule" {
  skip = true
  attrs = {
    bucket              = "bucket-no-rule"
    object_lock_enabled = "Enabled"
  }
}

# ---- FAIL: rule with empty default_retention ----
resource "aws_s3_bucket" "fail_empty_default_retention" {
  expect_failure = true
  attrs = {
    id     = "bucket-empty-retention"
    bucket = "bucket-empty-retention"
  }
}

resource "aws_s3_bucket_object_lock_configuration" "lock_empty_retention" {
  skip = true
  attrs = {
    bucket = "bucket-empty-retention"
    rule = [{
      default_retention = []
    }]
  }
}

# ---- FAIL: invalid mode ----
resource "aws_s3_bucket" "fail_invalid_mode" {
  expect_failure = true
  attrs = {
    id     = "bucket-invalid-mode"
    bucket = "bucket-invalid-mode"
  }
}

resource "aws_s3_bucket_object_lock_configuration" "lock_invalid_mode" {
  skip = true
  attrs = {
    bucket = "bucket-invalid-mode"
    rule = [{
      default_retention = [{
        mode = "OTHER"
        days = 5
      }]
    }]
  }
}

# ---- FAIL: mode missing (attribute omitted) ----
resource "aws_s3_bucket" "fail_missing_mode" {
  expect_failure = true
  attrs = {
    id     = "bucket-missing-mode"
    bucket = "bucket-missing-mode"
  }
}

resource "aws_s3_bucket_object_lock_configuration" "lock_missing_mode" {
  skip = true
  attrs = {
    bucket = "bucket-missing-mode"
    rule = [{
      default_retention = [{
        days = 5
      }]
    }]
  }
}

# ---- FAIL: mode explicitly null (policy treats null as non-compliant) ----
resource "aws_s3_bucket" "fail_null_mode" {
  expect_failure = true
  attrs = {
    id     = "bucket-null-mode"
    bucket = "bucket-null-mode"
  }
}

resource "aws_s3_bucket_object_lock_configuration" "lock_null_mode" {
  skip = true
  attrs = {
    bucket = "bucket-null-mode"
    rule = [{
      default_retention = [{
        mode = null
        days = 5
      }]
    }]
  }
}

# ---- FAIL: lock configuration references a different bucket ----
resource "aws_s3_bucket" "fail_other_bucket_locked" {
  expect_failure = true
  attrs = {
    id     = "bucket-unlocked"
    bucket = "bucket-unlocked"
  }
}

resource "aws_s3_bucket_object_lock_configuration" "lock_other_bucket" {
  skip = true
  attrs = {
    bucket = "some-other-bucket"
    rule = [{
      default_retention = [{
        mode = "COMPLIANCE"
        days = 30
      }]
    }]
  }
}

