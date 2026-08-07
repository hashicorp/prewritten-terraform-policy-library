# Copyright IBM Corp. 2026

# S3 general purpose buckets should have Lifecycle configurations

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "s3-lifecycle-policy-check-enforcement-level" {
  type    = string
  default = "advisory"
}

input "targetPrefix" {
  type    = string
  default = ""
}

input "targetTransitionDays" {
  type    = number
  default = 0
}

input "targetExpirationDays" {
  type    = number
  default = 0
}

input "targetTransitionStorageClass" {
  type    = string
  default = ""
}

input "bucketNames" {
  type    = string
  default = ""
}

locals {
  valid_storage_classes = [
    "STANDARD_IA",
    "INTELLIGENT_TIERING",
    "ONEZONE_IA",
    "GLACIER",
    "GLACIER_IR",
    "DEEP_ARCHIVE",
  ]
}

resource_policy "aws_s3_bucket" "lifecycle_policy_check" {
  enforcement_level = input.s3-lifecycle-policy-check-enforcement-level

  locals {
    bucket_name = core::try(attrs.bucket, "")
    bucket_in_scope = input.bucketNames == "" ? true : core::contains(core::split(",", input.bucketNames), local.bucket_name)

    valid_transition_days_input          = input.targetTransitionDays == 0 || (input.targetTransitionDays >= 1 && input.targetTransitionDays <= 36500)
    valid_expiration_days_input          = input.targetExpirationDays == 0 || (input.targetExpirationDays >= 1 && input.targetExpirationDays <= 36500)
    valid_transition_storage_class_input = input.targetTransitionStorageClass == "" || core::contains(local.valid_storage_classes, input.targetTransitionStorageClass)
  }

  enforce {
    condition     = local.valid_transition_days_input
    error_message = "input.targetTransitionDays must be between 1 and 36500 when provided. Current value: ${input.targetTransitionDays}. Use 0 to leave the parameter unset."
  }

  enforce {
    condition     = local.valid_expiration_days_input
    error_message = "input.targetExpirationDays must be between 1 and 36500 when provided. Current value: ${input.targetExpirationDays}. Use 0 to leave the parameter unset."
  }

  enforce {
    condition     = local.valid_transition_storage_class_input
    error_message = "input.targetTransitionStorageClass must be one of STANDARD_IA, INTELLIGENT_TIERING, ONEZONE_IA, GLACIER, GLACIER_IR, or DEEP_ARCHIVE when provided. Current value: '${input.targetTransitionStorageClass}'. Leave it empty to keep the parameter unset."
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
      condition = !local.bucket_in_scope || core::length([
        for rule in core::try(self.rule, []) :
        rule if (
          core::try(rule.status, "") == "Enabled" && (
            core::length(core::try(rule.transition, [])) > 0 ||
            core::try(rule.expiration, null) != null ||
            core::length(core::try(rule.noncurrent_version_transition, [])) > 0 ||
            core::try(rule.noncurrent_version_expiration, null) != null ||
            core::try(rule.abort_incomplete_multipart_upload, null) != null
          )
        )
      ]) > 0
      error_message = "S3 bucket '${local.bucket_name}' must have an 'aws_s3_bucket_lifecycle_configuration' with at least one Enabled rule that performs a lifecycle action"
    }

    enforce {
      condition = !local.bucket_in_scope || input.targetPrefix == "" || core::length([
        for rule in core::try(self.rule, []) :
        rule if core::try(rule.status, "") == "Enabled" && core::try(rule.prefix, core::try(rule.filter.prefix, core::try(rule.filter[0].prefix, ""))) == input.targetPrefix
      ]) > 0
      error_message = "S3 bucket lifecycle configuration does not include an enabled rule with prefix = '${input.targetPrefix}' as required by input.targetPrefix."
    }

    enforce {
      condition = !local.bucket_in_scope || input.targetTransitionDays == 0 || core::length([
        for rule in core::try(self.rule, []) :
        rule if core::try(rule.status, "") == "Enabled" && core::length([
          for transition in core::try(rule.transition, []) :
          transition if core::try(transition.days, 0) == input.targetTransitionDays
        ]) > 0
      ]) > 0
      error_message = "S3 bucket lifecycle configuration does not include a transition rule with days = ${input.targetTransitionDays} as required by input.targetTransitionDays."
    }

    enforce {
      condition = !local.bucket_in_scope || input.targetExpirationDays == 0 || core::length([
        for rule in core::try(self.rule, []) :
        rule if core::try(rule.status, "") == "Enabled" && core::try(core::try(rule.expiration, {}).days, 0) == input.targetExpirationDays
      ]) > 0
      error_message = "S3 bucket lifecycle configuration does not include an expiration rule with days = ${input.targetExpirationDays} as required by input.targetExpirationDays."
    }

    enforce {
      condition = !local.bucket_in_scope || input.targetTransitionStorageClass == "" || core::length([
        for rule in core::try(self.rule, []) :
        rule if core::try(rule.status, "") == "Enabled" && core::length([
          for transition in core::try(rule.transition, []) :
          transition if core::try(transition.storage_class, "") == input.targetTransitionStorageClass
        ]) > 0
      ]) > 0
      error_message = "S3 bucket lifecycle configuration does not include a transition rule with storage_class = '${input.targetTransitionStorageClass}' as required by input.targetTransitionStorageClass."
    }
  }
}
