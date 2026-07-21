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
  connected "aws_s3_bucket_logging" {
    min_instances = 1

    connection {
      subject   = "bucket"
      connected = "bucket"
    }

    filter = (
      core::try(connected.aws_s3_bucket_logging.target_bucket, "") != "" &&
      (input.targetBucket == "" || core::try(connected.aws_s3_bucket_logging.target_bucket, "") == input.targetBucket) &&
      (input.loggingTargetPrefix == "" || core::try(connected.aws_s3_bucket_logging.target_prefix, "") == input.loggingTargetPrefix)
    )
  }
}
