# Copyright IBM Corp. 2026

policytest {
  targets = ["cloudtrail-security-best-practices.policy.hcl"]
}

# PASS: fully compliant default
resource "aws_cloudtrail" "pass_fully_compliant_default" {
  attrs = {
    name                          = "compliant-trail"
    s3_bucket_name                = "compliant-bucket"
    enable_logging                = true
    include_global_service_events = true
    is_multi_region_trail         = true
    enable_log_file_validation    = true
    kms_key_id                    = "arn:aws:kms:us-east-1:123456789012:key/abcd1234-a123-456a-a12b-a123b4cd56ef"
  }
}

# PASS: logging null defaults true
resource "aws_cloudtrail" "pass_logging_null_defaults_true" {
  attrs = {
    name                          = "trail-logging-null"
    s3_bucket_name                = "compliant-bucket"
    enable_logging                = null
    include_global_service_events = true
    is_multi_region_trail         = true
    enable_log_file_validation    = true
    kms_key_id                    = "arn:aws:kms:us-east-1:123456789012:key/abcd1234-a123-456a-a12b-a123b4cd56ef"
  }
}

# PASS: basic selector all
resource "aws_cloudtrail" "pass_basic_selector_all" {
  attrs = {
    name                          = "trail-basic-selector-all"
    s3_bucket_name                = "compliant-bucket"
    enable_logging                = true
    include_global_service_events = true
    is_multi_region_trail         = true
    enable_log_file_validation    = true
    kms_key_id                    = "arn:aws:kms:us-east-1:123456789012:key/abcd1234-a123-456a-a12b-a123b4cd56ef"
    event_selector = [
      {
        include_management_events = true
        read_write_type           = "All"
      }
    ]
  }
}

# PASS: basic selector read and write
resource "aws_cloudtrail" "pass_basic_selector_read_and_write" {
  attrs = {
    name                          = "trail-basic-selector-read-write"
    s3_bucket_name                = "compliant-bucket"
    enable_logging                = true
    include_global_service_events = true
    is_multi_region_trail         = true
    enable_log_file_validation    = true
    kms_key_id                    = "arn:aws:kms:us-east-1:123456789012:key/abcd1234-a123-456a-a12b-a123b4cd56ef"
    event_selector = [
      {
        include_management_events = true
        read_write_type           = "ReadOnly"
      },
      {
        include_management_events = true
        read_write_type           = "WriteOnly"
      }
    ]
  }
}

# PASS: advanced selector full coverage
resource "aws_cloudtrail" "pass_advanced_selector_full_coverage" {
  attrs = {
    name                          = "trail-advanced-selector-full"
    s3_bucket_name                = "compliant-bucket"
    enable_logging                = true
    include_global_service_events = true
    is_multi_region_trail         = true
    enable_log_file_validation    = true
    kms_key_id                    = "arn:aws:kms:us-east-1:123456789012:key/abcd1234-a123-456a-a12b-a123b4cd56ef"
    advanced_event_selector = [
      {
        name = "management-events"
        field_selector = [
          {
            field  = "eventCategory"
            equals = ["Management"]
          }
        ]
      }
    ]
  }
}

# PASS: advanced selector read and write
resource "aws_cloudtrail" "pass_advanced_selector_read_and_write" {
  attrs = {
    name                          = "trail-advanced-selector-read-write"
    s3_bucket_name                = "compliant-bucket"
    enable_logging                = true
    include_global_service_events = true
    is_multi_region_trail         = true
    enable_log_file_validation    = true
    kms_key_id                    = "arn:aws:kms:us-east-1:123456789012:key/abcd1234-a123-456a-a12b-a123b4cd56ef"
    advanced_event_selector = [
      {
        name = "management-events-read"
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
      },
      {
        name = "management-events-write"
        field_selector = [
          {
            field  = "eventCategory"
            equals = ["Management"]
          },
          {
            field  = "readOnly"
            equals = ["false"]
          }
        ]
      }
    ]
  }
}

# PASS: A second, non-compliant regional trail is allowed when another trail in the plan is compliant
resource "aws_cloudtrail" "pass_noncompliant_trail_alongside_compliant" {
  attrs = {
    name           = "regional-only"
    s3_bucket_name = "trail-bucket"
  }
}
