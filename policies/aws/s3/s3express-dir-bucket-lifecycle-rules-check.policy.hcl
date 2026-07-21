# Copyright IBM Corp. 2026

# Policy: S3.25 - S3 directory buckets should have lifecycle configurations

policy {}

input "s3express-dir-bucket-lifecycle-rules-check-enforcement-level" {
  type = string
  default = "advisory"
}

input "expressTargetExpirationDays" {
  type    = number
  default = 0
}

resource_policy "aws_s3_directory_bucket" "directory_bucket_lifecycle" {
  enforcement_level = input.s3express-dir-bucket-lifecycle-rules-check-enforcement-level
  connected "aws_s3_bucket_lifecycle_configuration" {
    min_instances = 1

    connection {
      subject   = "bucket"
      connected = "bucket"
    }

    filter = (
      core::length([
        for rule in core::try(connected.aws_s3_bucket_lifecycle_configuration.rule, []) :
        rule if (
          core::try(rule.status, "") == "Enabled" && (
            core::length(core::try(rule.expiration, [])) > 0 ||
            core::length(core::try(rule.abort_incomplete_multipart_upload, [])) > 0
          )
        )
      ]) > 0 &&
      (input.expressTargetExpirationDays <= 0 || core::length([
        for rule in core::try(connected.aws_s3_bucket_lifecycle_configuration.rule, []) :
        rule if (
          core::try(rule.status, "") == "Enabled" &&
          core::try(rule.expiration[0].days, 0) == input.expressTargetExpirationDays
        )
      ]) > 0)
    )
  }
}

resource_policy "aws_s3_directory_bucket" "directory_bucket_lifecycle_input" {
  enforcement_level = input.s3express-dir-bucket-lifecycle-rules-check-enforcement-level

  enforce {
    condition     = input.expressTargetExpirationDays == 0 || (input.expressTargetExpirationDays >= 1 && input.expressTargetExpirationDays <= 2147483647)
    error_message = "input.expressTargetExpirationDays must be between 1 and 2147483647 when set. Current value: ${input.expressTargetExpirationDays}. Use 0 to leave the parameter unset."
  }
}
