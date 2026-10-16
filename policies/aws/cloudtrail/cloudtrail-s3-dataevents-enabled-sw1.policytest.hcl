# Copyright IBM Corp. 2026

policytest {
  targets = ["cloudtrail-s3-dataevents-enabled.policy.hcl"]
}

resource "aws_cloudtrail" "fail_starts_with_one_bucket" {
  expect_failure = true
  attrs = {
    name           = "trail-sw1"
    s3_bucket_name = "trail-logs-bucket"
    enable_logging = true
    advanced_event_selector = [{
      name = "S3 data events"
      field_selector = [
        { field = "eventCategory", equals = ["Data"] },
        { field = "resources.type", equals = ["AWS::S3::Object"] },
        { field = "resources.ARN", starts_with = ["arn:aws:s3:::only-bucket/"] },
      ]
    }]
  }
}
