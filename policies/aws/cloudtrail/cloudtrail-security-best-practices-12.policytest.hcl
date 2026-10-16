# Copyright IBM Corp. 2026

policytest {
  targets = ["cloudtrail-security-best-practices.policy.hcl"]
}

resource "aws_cloudtrail" "fail_basic_selector_has_excludes" {
  expect_failure = true
  attrs = {
    name                           = "trail-basic-selector-excludes"
    s3_bucket_name                 = "compliant-bucket"
    enable_logging                 = true
    include_global_service_events  = true
    is_multi_region_trail          = true
    enable_log_file_validation     = true
    kms_key_id                     = "arn:aws:kms:us-east-1:123456789012:key/abcd1234-a123-456a-a12b-a123b4cd56ef"
    event_selector = [
      {
        include_management_events        = true
        read_write_type                   = "All"
        exclude_management_event_sources  = ["kms.amazonaws.com"]
      }
    ]
  }
}
