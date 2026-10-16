# Copyright IBM Corp. 2026

policytest {
  targets = ["cloudtrail-security-best-practices.policy.hcl"]
}

resource "aws_cloudtrail" "fail_kms_key_empty" {
  expect_failure = true
  attrs = {
    name                           = "trail-kms-key-empty"
    s3_bucket_name                 = "compliant-bucket"
    enable_logging                 = true
    include_global_service_events  = true
    is_multi_region_trail          = true
    enable_log_file_validation     = true
    kms_key_id                     = ""
  }
}
