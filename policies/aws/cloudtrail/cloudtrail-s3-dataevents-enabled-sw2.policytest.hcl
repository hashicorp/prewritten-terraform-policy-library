# Copyright IBM Corp. 2026

policytest {
  targets = ["cloudtrail-s3-dataevents-enabled.policy.hcl"]
}

inputs {
  cloudtrail-s3-dataevents-enabled-s3_bucket_names = "target-bucket"
}
resource "aws_cloudtrail" "pass_starts_with_target_bucket" {

  attrs = {
    name           = "trail-sw2"
    s3_bucket_name = "trail-logs-bucket"
    enable_logging = true
    advanced_event_selector = [{
      name = "S3 data events"
      field_selector = [
        { field = "eventCategory", equals = ["Data"] },
        { field = "resources.type", equals = ["AWS::S3::Object"] },
        { field = "resources.ARN", starts_with = ["arn:aws:s3:::target-bucket/"] },
      ]
    }]
  }
}
