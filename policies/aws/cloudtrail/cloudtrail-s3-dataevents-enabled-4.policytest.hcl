# Copyright IBM Corp. 2026

policytest {
  targets = ["cloudtrail-s3-dataevents-enabled.policy.hcl"]
}

resource "aws_cloudtrail" "fail_logging_disabled" {
  expect_failure = true
  attrs = {
    name           = "trail-logging-disabled"
    s3_bucket_name = "trail-logs-bucket"
    enable_logging = false
    event_selector = [{
      read_write_type = "All"
      data_resource = [{
        type   = "AWS::S3::Object"
        values = ["arn:aws:s3:::"]
      }]
    }]
  }
}
