# Copyright IBM Corp. 2026

# Ensure S3 bucket access logging is enabled on the CloudTrail S3 bucket

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "cloudtrail-bucket-access-logging-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_cloudtrail" "cloudtrail_bucket_access_logging_enabled" {
  locals {
    s3_bucket_name = core::try(attrs.s3_bucket_name, "")
    logging_buckets = core::getresources("aws_s3_bucket_logging", {
      bucket = local.s3_bucket_name
    })
    access_logged_buckets = [for logging in local.logging_buckets : logging
      if core::try(logging.bucket, "") != "" &&
      core::try(logging.target_bucket, "") != "" &&
      core::try(logging.target_prefix, "") != ""
    ]
    has_access_logging = core::length(local.access_logged_buckets) > 0
  }

  enforcement_level = input.cloudtrail-bucket-access-logging-enabled-enforcement-level
  enforce {
    condition     = local.s3_bucket_name != "" && local.has_access_logging
    error_message = "Cloudtrail S3 buckets must have access logging enabled"
  }
}
