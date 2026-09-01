# Copyright IBM Corp. 2026

# S3 directory buckets should have lifecycle configurations

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.28.0, < 7.0.0"
    }
  }
}

input "s3express-dir-bucket-lifecycle-rules-check-enforcement-level" {
  type    = string
  default = "advisory"
}

input "expressTargetExpirationDays" {
  type    = number
  default = 0
}

resource_policy "aws_s3_directory_bucket" "directory_bucket_lifecycle" {
  enforcement_level = input.s3express-dir-bucket-lifecycle-rules-check-enforcement-level

  locals {
    valid_target_expiration_days_input = input.expressTargetExpirationDays == 0 || (input.expressTargetExpirationDays >= 1 && input.expressTargetExpirationDays <= 2147483647)
  }

  enforce {
    condition     = local.valid_target_expiration_days_input
    error_message = "input.expressTargetExpirationDays must be between 1 and 2147483647 when set. Current value: ${input.expressTargetExpirationDays}. Use 0 to leave the parameter unset."
  }

  connected "aws_s3_bucket_lifecycle_configuration" {
    connection {
      subject = "bucket"
      target  = "bucket"
    }

    cardinality = {
      min_matches = 1
    }

    enforce {
      condition = core::length([
        for rule in core::try(self.rule, []) :
        rule if (
          core::try(rule.status, "") == "Enabled" && (
            core::length(core::try(rule.expiration, [])) > 0 ||
            core::length(core::try(rule.abort_incomplete_multipart_upload, [])) > 0
          )
        )
      ]) > 0
      error_message = "S3 directory bucket must have an associated 'aws_s3_bucket_lifecycle_configuration' with at least one Enabled rule with expiration or abort_incomplete_multipart_upload configured"
    }

    enforce {
      condition = input.expressTargetExpirationDays == 0 || core::length([
        for rule in core::try(self.rule, []) :
        rule if core::try(rule.status, "") == "Enabled" && core::try(rule.expiration[0].days, 0) == input.expressTargetExpirationDays
      ]) > 0
      error_message = "S3 directory bucket lifecycle configuration must include an enabled rule with expiration.days = ${input.expressTargetExpirationDays} as required by input.expressTargetExpirationDays"
    }
  }
}
