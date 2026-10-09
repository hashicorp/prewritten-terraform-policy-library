# Copyright IBM Corp. 2026

policytest {
  targets = ["cloudtrail-enabled.policy.hcl"]
}

# ---- PASS cases ----

resource "aws_cloudtrail" "pass_logging_default" {
  attrs = {
    name           = "pass-logging-default"
    s3_bucket_name = "trail-bucket"
  }
}

resource "aws_cloudtrail" "pass_logging_true" {
  attrs = {
    name           = "pass-logging-true"
    s3_bucket_name = "trail-bucket"
    enable_logging = true
  }
}

resource "aws_cloudtrail" "pass_logging_null" {
  attrs = {
    name           = "pass-logging-null"
    s3_bucket_name = "trail-bucket"
    enable_logging = null
  }
}

resource "aws_cloudtrail" "pass_multi_region_logging_true" {
  attrs = {
    name                  = "pass-multi-region"
    s3_bucket_name        = "trail-bucket"
    is_multi_region_trail = true
    enable_logging        = true
  }
}

resource "aws_cloudtrail" "pass_organization_trail" {
  attrs = {
    name                  = "pass-org-trail"
    s3_bucket_name        = "trail-bucket"
    is_organization_trail = true
  }
}

resource "aws_cloudtrail" "pass_fully_configured" {
  attrs = {
    name                       = "pass-full"
    s3_bucket_name             = "trail-bucket"
    enable_logging             = true
    enable_log_file_validation = true
    include_global_service_events = true
    kms_key_id                 = "arn:aws:kms:us-east-1:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab"
    cloud_watch_logs_group_arn = "arn:aws:logs:us-east-1:111122223333:log-group:trail:*"
  }
}

# ---- FAIL cases ----

resource "aws_cloudtrail" "fail_logging_false" {
  expect_failure = true
  attrs = {
    name           = "fail-logging-false"
    s3_bucket_name = "trail-bucket"
    enable_logging = false
  }
}

resource "aws_cloudtrail" "fail_multi_region_logging_false" {
  expect_failure = true
  attrs = {
    name                  = "fail-multi-region"
    s3_bucket_name        = "trail-bucket"
    is_multi_region_trail = true
    enable_logging        = false
  }
}

resource "aws_cloudtrail" "fail_organization_logging_false" {
  expect_failure = true
  attrs = {
    name                  = "fail-org-trail"
    s3_bucket_name        = "trail-bucket"
    is_organization_trail = true
    enable_logging        = false
  }
}

resource "aws_cloudtrail" "fail_logging_false_other_settings_ok" {
  expect_failure = true
  attrs = {
    name                       = "fail-other-ok"
    s3_bucket_name             = "trail-bucket"
    enable_logging             = false
    enable_log_file_validation = true
    kms_key_id                 = "arn:aws:kms:us-east-1:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab"
  }
}
