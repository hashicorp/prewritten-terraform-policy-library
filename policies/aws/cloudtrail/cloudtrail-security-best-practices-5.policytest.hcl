# Copyright IBM Corp. 2026

policytest {
  targets = ["cloudtrail-security-best-practices.policy.hcl"]
}

resource "aws_cloudtrail" "fail_missing_multi_region_defaults_false" {
  expect_failure = true
  attrs = {
    name                           = "trail-missing-multi-region"
    s3_bucket_name                 = "compliant-bucket"
    enable_logging                 = true
    include_global_service_events  = true
    enable_log_file_validation     = true
    kms_key_id                     = "arn:aws:kms:us-east-1:123456789012:key/abcd1234-a123-456a-a12b-a123b4cd56ef"
  }
}
