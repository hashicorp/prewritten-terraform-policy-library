# Copyright IBM Corp. 2026

# Policy: S3.9 - S3 general purpose buckets should have server access logging enabled

policy {}

input "s3-bucket-logging-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

input "targetBucket" {
  type    = string
  default = ""
}

input "loggingTargetPrefix" {
  type    = string
  default = ""
}

resource_policy "aws_s3_bucket" "server_access_logging_enabled" {
  enforcement_level = input.s3-bucket-logging-enabled-enforcement-level
  locals {
    bucket_name = core::try(attrs.bucket, "")

    # Look up the aws_s3_bucket_logging resource that references this bucket.
    matching_logging = core::getresources("aws_s3_bucket_logging", {
      bucket = local.bucket_name
    })

    has_logging   = core::length(local.matching_logging) > 0
    logging       = local.has_logging ? local.matching_logging[0] : null
    target_bucket = core::try(local.logging.target_bucket, "")
    target_prefix = core::try(local.logging.target_prefix, "")

    has_target_bucket_input = input.targetBucket != ""
    has_target_prefix_input = input.loggingTargetPrefix != ""

    matches_target_bucket = !local.has_target_bucket_input || local.target_bucket == input.targetBucket
    matches_target_prefix = !local.has_target_prefix_input || local.target_prefix == input.loggingTargetPrefix
  }

  enforce {
    condition     = local.has_logging && local.target_bucket != ""
    error_message = "S3 bucket '${local.bucket_name}' must have an associated 'aws_s3_bucket_logging' resource with a non-empty 'target_bucket' to enable server access logging. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-9 for more details."
  }

  enforce {
    condition     = local.matches_target_bucket
    error_message = "S3 bucket '${local.bucket_name}' logging target_bucket '${local.target_bucket}' does not match the required value '${input.targetBucket}' set via input.targetBucket. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-9 for more details."
  }

  enforce {
    condition     = local.matches_target_prefix
    error_message = "S3 bucket '${local.bucket_name}' logging target_prefix '${local.target_prefix}' does not match the required value '${input.loggingTargetPrefix}' set via input.loggingTargetPrefix. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-9 for more details."
  }
}
