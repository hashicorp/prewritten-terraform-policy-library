# Copyright IBM Corp. 2026

policytest {
  targets = ["cloudtrail-security-best-practices.policy.hcl"]
}

resource "aws_cloudtrail" "fail_advanced_selector_read_only_only" {
  expect_failure = true
  attrs = {
    name                           = "trail-advanced-selector-read-only"
    s3_bucket_name                 = "compliant-bucket"
    enable_logging                 = true
    include_global_service_events  = true
    is_multi_region_trail          = true
    enable_log_file_validation     = true
    kms_key_id                     = "arn:aws:kms:us-east-1:123456789012:key/abcd1234-a123-456a-a12b-a123b4cd56ef"
    advanced_event_selector = [
      {
        name = "management-events-read-only"
        field_selector = [
          {
            field  = "eventCategory"
            equals = ["Management"]
          },
          {
            field  = "readOnly"
            equals = ["true"]
          }
        ]
      }
    ]
  }
}
