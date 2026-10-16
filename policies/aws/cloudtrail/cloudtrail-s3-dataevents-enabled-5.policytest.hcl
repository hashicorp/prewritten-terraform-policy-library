# Copyright IBM Corp. 2026

policytest {
  targets = ["cloudtrail-s3-dataevents-enabled.policy.hcl"]
}

resource "aws_cloudtrail" "fail_legacy_write_only" {
  expect_failure = true
  attrs = {
    name           = "trail-legacy-writeonly"
    s3_bucket_name = "trail-logs-bucket"
    enable_logging = true
    event_selector = [{
      read_write_type = "WriteOnly"
      data_resource = [{
        type   = "AWS::S3::Object"
        values = ["arn:aws:s3:::"]
      }]
    }]
  }
}
