# Copyright IBM Corp. 2026

policytest {
  targets = ["cloudtrail-bucket-access-logging-enabled.policy.hcl"]
}

resource "aws_s3_bucket_logging" "logged_cloudtrail_bucket" {
  skip = true
  attrs = {
    bucket        = "logged-cloudtrail-bucket"
    target_bucket = "access-log-destination"
    target_prefix = "cloudtrail-access/"
  }
}

resource "aws_cloudtrail" "pass_matching_logging_bucket" {
  attrs = {
    name           = "logged-trail"
    s3_bucket_name = "logged-cloudtrail-bucket"
  }
}

# The optional enable_logging attribute is intentionally omitted while all required
# attributes remain present; the unmatched bucket must still produce a violation.
resource "aws_cloudtrail" "fail_unlogged_bucket" {
  expect_failure = true
  attrs = {
    name           = "unlogged-trail"
    s3_bucket_name = "unlogged-cloudtrail-bucket"
  }
}

resource "aws_s3_bucket_logging" "missing_target_bucket" {
  skip = true
  attrs = {
    bucket        = "missing-target-bucket"
    target_bucket = ""
    target_prefix = "cloudtrail-access/"
  }
}

resource "aws_cloudtrail" "fail_missing_target_bucket" {
  expect_failure = true
  attrs = {
    name           = "missing-target-bucket-trail"
    s3_bucket_name = "missing-target-bucket"
  }
}

resource "aws_cloudtrail" "fail_unresolved_bucket" {
  expect_failure = true
  attrs = {
    name           = "unresolved-trail"
    s3_bucket_name = ""
  }
}
