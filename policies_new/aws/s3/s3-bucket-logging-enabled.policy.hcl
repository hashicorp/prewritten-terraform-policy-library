# Copyright IBM Corp. 2026

# S3 general purpose buckets should have server access logging enabled

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "s3-bucket-logging-enabled-enforcement-level" {
  type    = string
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

  connected "aws_s3_bucket_logging" {
    connection {
      subject = "bucket"
      target  = "bucket"
    }

    cardinality = {
      min_matches = 1
    }

    enforce {
      condition     = core::try(self.target_bucket, "") != ""
      error_message = "S3 bucket must have an associated 'aws_s3_bucket_logging' resource with a non-empty 'target_bucket' to enable server access logging"
    }

    enforce {
      condition     = input.targetBucket == "" || core::try(self.target_bucket, "") == input.targetBucket
      error_message = "S3 bucket logging target_bucket does not match the required value '${input.targetBucket}' set via input.targetBucket"
    }

    enforce {
      condition     = input.loggingTargetPrefix == "" || core::try(self.target_prefix, "") == input.loggingTargetPrefix
      error_message = "S3 bucket logging target_prefix does not match the required value '${input.loggingTargetPrefix}' set via input.loggingTargetPrefix"
    }
  }
}
