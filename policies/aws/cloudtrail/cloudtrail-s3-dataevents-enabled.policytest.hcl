# Copyright IBM Corp. 2026

policytest {
  targets = ["cloudtrail-s3-dataevents-enabled.policy.hcl"]
}

inputs {
  cloudtrail-s3-dataevents-enabled-s3_bucket_names = "my-target-bucket"
}

resource "aws_cloudtrail" "pass_legacy_target_bucket_matched" {
  attrs = {
    name           = "trail-target-matched"
    s3_bucket_name = "trail-logs-bucket"
    enable_logging = true
    event_selector = [{
      read_write_type = "All"
      data_resource = [{
        type   = "AWS::S3::Object"
        values = ["arn:aws:s3:::my-target-bucket/"]
      }]
    }]
  }
}

resource "aws_cloudtrail" "pass_legacy_all_pattern_covers_target" {
  attrs = {
    name           = "trail-all-pattern-covers-target"
    s3_bucket_name = "trail-logs-bucket"
    enable_logging = true
    event_selector = [{
      read_write_type = "All"
      data_resource = [{
        type   = "AWS::S3::Object"
        values = ["arn:aws:s3:::*/*"]
      }]
    }]
  }
}

# ---- Cases merged from cloudtrail-s3-dataevents-enabled-p1.policytest.hcl ----

resource "aws_cloudtrail" "pass_legacy_all_buckets_f11" {
  attrs = {
    name           = "trail-legacy-all"
    s3_bucket_name = "trail-logs-bucket"
    enable_logging = true
    event_selector = [{
      read_write_type = "All"
      data_resource = [{
        type   = "AWS::S3::Object"
        values = ["arn:aws:s3:::"]
      }]
    }]
  }
}

resource "aws_cloudtrail" "pass_advanced_all_buckets_f11" {
  attrs = {
    name           = "trail-advanced-all"
    s3_bucket_name = "trail-logs-bucket"
    enable_logging = true
    advanced_event_selector = [{
      name = "S3 data events"
      field_selector = [
        { field = "eventCategory", equals = ["Data"] },
        { field = "resources.type", equals = ["AWS::S3::Object"] },
        { field = "resources.ARN", equals = ["arn:aws:s3:::*/*"] },
      ]
    }]
  }
}

resource "aws_cloudtrail" "pass_legacy_empty_values_f11" {
  attrs = {
    name           = "trail-legacy-empty-values"
    s3_bucket_name = "trail-logs-bucket"
    enable_logging = true
    event_selector = [{
      read_write_type = "All"
      data_resource = [{
        type   = "AWS::S3::Object"
        values = []
      }]
    }]
  }
}

resource "aws_cloudtrail" "pass_enable_logging_omitted_f11" {
  attrs = {
    name           = "trail-logging-omitted"
    s3_bucket_name = "trail-logs-bucket"
    event_selector = [{
      read_write_type = "All"
      data_resource = [{
        type   = "AWS::S3::Object"
        values = ["arn:aws:s3:::"]
      }]
    }]
  }
}

resource "aws_cloudtrail" "pass_enable_logging_null_f11" {
  attrs = {
    name           = "trail-logging-null"
    s3_bucket_name = "trail-logs-bucket"
    enable_logging = null
    event_selector = [{
      read_write_type = "All"
      data_resource = [{
        type   = "AWS::S3::Object"
        values = ["arn:aws:s3:::"]
      }]
    }]
  }
}

# A trail without S3 data events is allowed when another trail in the plan logs them.
resource "aws_cloudtrail" "pass_management_only_trail_alongside_compliant_f11" {
  attrs = {
    name           = "management-only"
    s3_bucket_name = "trail-logs-bucket"
  }
}

# ---- Cases merged from cloudtrail-s3-dataevents-enabled-sw2.policytest.hcl ----

resource "aws_cloudtrail" "pass_starts_with_target_bucket_f13" {

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
