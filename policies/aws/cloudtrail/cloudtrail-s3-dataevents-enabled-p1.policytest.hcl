# Copyright IBM Corp. 2026

policytest {
  targets = ["cloudtrail-s3-dataevents-enabled.policy.hcl"]
}

resource "aws_cloudtrail" "pass_legacy_all_buckets" {
  attrs = {
    name            = "trail-legacy-all"
    s3_bucket_name  = "trail-logs-bucket"
    enable_logging  = true
    event_selector = [{
      read_write_type = "All"
      data_resource = [{
        type   = "AWS::S3::Object"
        values = ["arn:aws:s3:::"]
      }]
    }]
  }
}

resource "aws_cloudtrail" "pass_advanced_all_buckets" {
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

resource "aws_cloudtrail" "pass_legacy_empty_values" {
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

resource "aws_cloudtrail" "pass_enable_logging_omitted" {
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

resource "aws_cloudtrail" "pass_enable_logging_null" {
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
resource "aws_cloudtrail" "pass_management_only_trail_alongside_compliant" {
  attrs = {
    name           = "management-only"
    s3_bucket_name = "trail-logs-bucket"
  }
}
