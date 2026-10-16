# Copyright IBM Corp. 2026

policytest {
  targets = ["cloudtrail-s3-dataevents-enabled.policy.hcl"]
}

resource "aws_cloudtrail" "fail_advanced_wrong_resource_type" {
  expect_failure = true
  attrs = {
    name           = "trail-advanced-wrong-type"
    s3_bucket_name = "trail-logs-bucket"
    enable_logging = true
    advanced_event_selector = [{
      name = "Lambda data events"
      field_selector = [
        { field = "eventCategory", equals = ["Data"] },
        { field = "resources.type", equals = ["AWS::Lambda::Function"] },
      ]
    }]
  }
}
