# Copyright IBM Corp. 2026

policytest {
  targets = ["cloudtrail-s3-dataevents-enabled.policy.hcl"]
}

resource "aws_cloudtrail" "fail_no_selectors" {
  expect_failure = true
  attrs = {
    name           = "trail-no-selectors"
    s3_bucket_name = "trail-logs-bucket"
    enable_logging = true
  }
}
