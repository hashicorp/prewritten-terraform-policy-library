# Copyright IBM Corp. 2026

policytest {
  targets = ["s3-bucket-should-have-object-lock-enabled.policy.hcl"]
}

# ---- Compliant buckets ----
resource "aws_s3_bucket" "pass_compliance" {
  attrs = {
    id     = "bucket-compliance"
    bucket = "bucket-compliance"
  }
}
resource "aws_s3_bucket_object_lock_configuration" "lock_compliance" {
  attrs = {
    bucket              = "bucket-compliance"
    object_lock_enabled = "Enabled"
    rule = [{
      default_retention = [{
        mode = "COMPLIANCE"
        days = 5
      }]
    }]
  }
}

resource "aws_s3_bucket" "pass_governance" {
  attrs = {
    id     = "bucket-governance"
    bucket = "bucket-governance"
  }
}
resource "aws_s3_bucket_object_lock_configuration" "lock_governance" {
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

resource "aws_s3_bucket" "pass_mixed_configs" {
  attrs = {
    id     = "bucket-mixed"
    bucket = "bucket-mixed"
  }
}
resource "aws_s3_bucket_object_lock_configuration" "lock_mixed_bad" {
  attrs = {
    bucket = "bucket-mixed"
    rule = [{
      default_retention = [{
        mode = "INVALID"
        days = 1
      }]
    }]
  }
}
resource "aws_s3_bucket_object_lock_configuration" "lock_mixed_good" {
  attrs = {
    bucket = "bucket-mixed"
    rule = [{
      default_retention = [{
        mode = "COMPLIANCE"
        days = 1
      }]
    }]
  }
}

# ---- Non-compliant buckets ----
resource "aws_s3_bucket" "fail_no_lock_config" {
  expect_failure = true
  attrs = {
    id     = "bucket-no-lock"
    bucket = "bucket-no-lock"
  }
}

resource "aws_s3_bucket" "fail_object_lock_enabled_only" {
  expect_failure = true
  attrs = {
    id                  = "bucket-flag-only"
    bucket              = "bucket-flag-only"
    object_lock_enabled = true
  }
}

resource "aws_s3_bucket" "fail_missing_rule" {
  expect_failure = true
  attrs = {
    id     = "bucket-no-rule"
    bucket = "bucket-no-rule"
  }
}
resource "aws_s3_bucket_object_lock_configuration" "lock_no_rule" {
  attrs = {
    bucket              = "bucket-no-rule"
    object_lock_enabled = "Enabled"
  }
}

resource "aws_s3_bucket" "fail_missing_mode" {
  expect_failure = true
  attrs = {
    id     = "bucket-no-mode"
    bucket = "bucket-no-mode"
  }
}
resource "aws_s3_bucket_object_lock_configuration" "lock_no_mode" {
  attrs = {
    bucket = "bucket-no-mode"
    rule = [{
      default_retention = [{
        days = 3
      }]
    }]
  }
}

resource "aws_s3_bucket" "fail_invalid_mode" {
  expect_failure = true
  attrs = {
    id     = "bucket-invalid-mode"
    bucket = "bucket-invalid-mode"
  }
}
resource "aws_s3_bucket_object_lock_configuration" "lock_invalid_mode" {
  attrs = {
    bucket = "bucket-invalid-mode"
    rule = [{
      default_retention = [{
        mode = "INVALID"
        days = 3
      }]
    }]
  }
}

resource "aws_s3_bucket" "fail_config_other_bucket" {
  expect_failure = true
  attrs = {
    id     = "bucket-orphan"
    bucket = "bucket-orphan"
  }
}
resource "aws_s3_bucket_object_lock_configuration" "lock_other_bucket" {
  attrs = {
    bucket = "some-other-bucket"
    rule = [{
      default_retention = [{
        mode = "COMPLIANCE"
        days = 3
      }]
    }]
  }
}
