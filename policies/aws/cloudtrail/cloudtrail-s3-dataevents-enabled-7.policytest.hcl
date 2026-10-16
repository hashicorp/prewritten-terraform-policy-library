# Copyright IBM Corp. 2026

policytest {
  targets = ["cloudtrail-s3-dataevents-enabled.policy.hcl"]
}

resource "aws_cloudtrail" "fail_advanced_event_name_filter" {
  expect_failure = true
  attrs = {
    name           = "trail-advanced-eventname"
    s3_bucket_name = "trail-logs-bucket"
    enable_logging = true
    advanced_event_selector = [{
      name = "S3 restricted data events"
      field_selector = [
        { field = "eventCategory", equals = ["Data"] },
        { field = "resources.type", equals = ["AWS::S3::Object"] },
        { field = "resources.ARN", equals = ["arn:aws:s3:::*/*"] },
        { field = "eventName", equals = ["PutObject"] },
      ]
    }]
  }
}
