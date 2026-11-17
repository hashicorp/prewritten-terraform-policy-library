# Copyright IBM Corp. 2026

policytest {
  targets = ["cloudtrail-s3-dataevents-enabled.policy.hcl"]
}

inputs {
  cloudtrail-s3-dataevents-enabled-s3_bucket_names = "my-target-bucket"
}

# FAIL: a prefix does not enable data events for the whole target bucket
resource "aws_cloudtrail" "fail_legacy_target_bucket_prefix" {
  expect_failure = true
  attrs = {
    name           = "trail-target-prefix"
    s3_bucket_name = "trail-logs-bucket"
    enable_logging = true
    event_selector = [{
      read_write_type = "All"
      data_resource = [{
        type   = "AWS::S3::Object"
        values = ["arn:aws:s3:::my-target-bucket/private/"]
      }]
    }]
  }
}
