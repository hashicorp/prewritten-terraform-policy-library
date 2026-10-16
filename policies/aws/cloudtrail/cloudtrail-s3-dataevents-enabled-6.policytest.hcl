# Copyright IBM Corp. 2026

policytest {
  targets = ["cloudtrail-s3-dataevents-enabled.policy.hcl"]
}

resource "aws_cloudtrail" "fail_legacy_wrong_type" {
  expect_failure = true
  attrs = {
    name           = "trail-legacy-wrong-type"
    s3_bucket_name = "trail-logs-bucket"
    enable_logging = true
    event_selector = [{
      read_write_type = "All"
      data_resource = [{
        type   = "AWS::Lambda::Function"
        values = ["arn:aws:lambda:::function:*"]
      }]
    }]
  }
}
