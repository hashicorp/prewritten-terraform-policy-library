# Copyright IBM Corp. 2026

policytest {
  targets = ["s3-bucket-mfa-delete-enabled.policy.hcl"]
}

# ──────────────────────────────────────────────────────────────
# PASS cases
# ──────────────────────────────────────────────────────────────

# Test 1: PASS - bucket with versioning enabled and mfa_delete enabled
resource "aws_s3_bucket" "pass_mfa_delete_enabled" {
  attrs = {
    bucket = "pass-mfa-delete-enabled"
  }
}

resource "aws_s3_bucket_versioning" "pass_mfa_delete_enabled" {
  skip = true
  attrs = {
    bucket = "pass-mfa-delete-enabled"
    mfa    = "arn:aws:iam::123456789012:mfa/test 123456"
    versioning_configuration = [{
      status     = "Enabled"
      mfa_delete = "Enabled"
    }]
  }
}

# Test 2: PASS - bucket with versioning and mfa_delete, extra attributes present
resource "aws_s3_bucket" "pass_mfa_delete_with_tags" {
  attrs = {
    bucket = "pass-mfa-delete-tags"
    tags   = { Environment = "prod" }
  }
}

resource "aws_s3_bucket_versioning" "pass_mfa_delete_with_tags" {
  skip = true
  attrs = {
    bucket = "pass-mfa-delete-tags"
    mfa    = "arn:aws:iam::123456789012:mfa/test 654321"
    versioning_configuration = [{
      status     = "Enabled"
      mfa_delete = "Enabled"
    }]
  }
}

# ──────────────────────────────────────────────────────────────
# FAIL cases
# ──────────────────────────────────────────────────────────────

# Test 3: FAIL - bucket has no aws_s3_bucket_versioning resource at all
resource "aws_s3_bucket" "fail_no_versioning_resource" {
  expect_failure = true
  attrs = {
    bucket = "fail-no-versioning"
  }
}

# Test 4: FAIL - versioning status is Suspended (not Enabled)
resource "aws_s3_bucket" "fail_suspended_versioning" {
  expect_failure = true
  attrs = {
    bucket = "fail-suspended-versioning"
  }
}

resource "aws_s3_bucket_versioning" "fail_suspended_versioning" {
  skip = true
  attrs = {
    bucket = "fail-suspended-versioning"
    mfa    = "arn:aws:iam::123456789012:mfa/test 123456"
    versioning_configuration = [{
      status     = "Suspended"
      mfa_delete = "Enabled"
    }]
  }
}

# Test 5: FAIL - mfa_delete is Disabled
resource "aws_s3_bucket" "fail_mfa_delete_disabled" {
  expect_failure = true
  attrs = {
    bucket = "fail-mfa-delete-disabled"
  }
}

resource "aws_s3_bucket_versioning" "fail_mfa_delete_disabled" {
  skip = true
  attrs = {
    bucket = "fail-mfa-delete-disabled"
    versioning_configuration = [{
      status     = "Enabled"
      mfa_delete = "Disabled"
    }]
  }
}

# Test 6: FAIL - mfa_delete is omitted entirely
resource "aws_s3_bucket" "fail_mfa_delete_omitted" {
  expect_failure = true
  attrs = {
    bucket = "fail-mfa-delete-omitted"
  }
}

resource "aws_s3_bucket_versioning" "fail_mfa_delete_omitted" {
  skip = true
  attrs = {
    bucket = "fail-mfa-delete-omitted"
    versioning_configuration = [{
      status = "Enabled"
    }]
  }
}

# Test 7: FAIL - mfa_delete is explicitly null
resource "aws_s3_bucket" "fail_mfa_delete_null" {
  expect_failure = true
  attrs = {
    bucket = "fail-mfa-delete-null"
  }
}

resource "aws_s3_bucket_versioning" "fail_mfa_delete_null" {
  skip = true
  attrs = {
    bucket = "fail-mfa-delete-null"
    versioning_configuration = [{
      status     = "Enabled"
      mfa_delete = null
    }]
  }
}

# Test 8: FAIL - versioning_configuration list is empty
resource "aws_s3_bucket" "fail_empty_versioning_config" {
  expect_failure = true
  attrs = {
    bucket = "fail-empty-versioning-config"
  }
}

resource "aws_s3_bucket_versioning" "fail_empty_versioning_config" {
  skip = true
  attrs = {
    bucket                   = "fail-empty-versioning-config"
    versioning_configuration = []
  }
}
