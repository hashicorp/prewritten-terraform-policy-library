# Copyright IBM Corp. 2026

# S3.13 - S3 General Purpose Buckets Should Have Lifecycle Configurations
# AWS Config rule: s3-lifecycle-policy-check
#
# NON_COMPLIANT if there is no active lifecycle configuration rule or the
# configuration does not match the optional parameter values.

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "s3-lifecycle-policy-check-enforcement-level" {
  type = string
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
  filter = input.bucketNames == "" ? true : core::contains(core::split(",", input.bucketNames), core::try(attrs.bucket, ""))

  locals {
    has_target_prefix_input            = input.targetPrefix != ""
    has_transition_days_input          = input.targetTransitionDays > 0
    has_expiration_days_input          = input.targetExpirationDays > 0
    has_transition_storage_class_input = input.targetTransitionStorageClass != ""
  }

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
            core::length(core::try(rule.transition, [])) > 0 ||
            core::try(rule.expiration, null) != null ||
            core::length(core::try(rule.noncurrent_version_transition, [])) > 0 ||
            core::try(rule.noncurrent_version_expiration, null) != null ||
            core::try(rule.abort_incomplete_multipart_upload, null) != null
          )
        )
      ]) > 0 &&
      core::length([
        for rule in core::try(connected.aws_s3_bucket_lifecycle_configuration.rule, []) :
        rule if core::try(rule.status, "") == "Enabled" && core::length([
          for transition in core::try(rule.transition, []) :
          transition if !core::contains(local.valid_storage_classes, core::try(transition.storage_class, ""))
        ]) > 0
      ]) == 0 &&
      (!local.has_target_prefix_input || core::length([
        for rule in core::try(connected.aws_s3_bucket_lifecycle_configuration.rule, []) :
        rule if (
          core::try(rule.status, "") == "Enabled" && (
            core::length(core::try(rule.transition, [])) > 0 ||
            core::try(rule.expiration, null) != null ||
            core::length(core::try(rule.noncurrent_version_transition, [])) > 0 ||
            core::try(rule.noncurrent_version_expiration, null) != null ||
            core::try(rule.abort_incomplete_multipart_upload, null) != null
          ) &&
          core::try(rule.prefix, core::try(rule.filter.prefix, core::try(rule.filter[0].prefix, ""))) == input.targetPrefix
        )
      ]) > 0) &&
      (!local.has_transition_days_input || core::length([
        for rule in core::try(connected.aws_s3_bucket_lifecycle_configuration.rule, []) :
        rule if core::try(rule.status, "") == "Enabled" && core::length([
          for transition in core::try(rule.transition, []) :
          transition if core::try(transition.days, 0) == input.targetTransitionDays
        ]) > 0
      ]) > 0) &&
      (!local.has_expiration_days_input || core::length([
        for rule in core::try(connected.aws_s3_bucket_lifecycle_configuration.rule, []) :
        rule if core::try(rule.status, "") == "Enabled" && core::try(core::try(rule.expiration, {}).days, 0) == input.targetExpirationDays
      ]) > 0) &&
      (!local.has_transition_storage_class_input || core::length([
        for rule in core::try(connected.aws_s3_bucket_lifecycle_configuration.rule, []) :
        rule if core::try(rule.status, "") == "Enabled" && core::length([
          for transition in core::try(rule.transition, []) :
          transition if core::try(transition.storage_class, "") == input.targetTransitionStorageClass
        ]) > 0
      ]) > 0)
    )
  }
}

resource_policy "aws_s3_bucket" "lifecycle_policy_check_inputs" {
  enforcement_level = input.s3-lifecycle-policy-check-enforcement-level

  enforce {
    condition     = input.targetTransitionDays <= 0 || (input.targetTransitionDays >= 1 && input.targetTransitionDays <= 36500)
    error_message = "input.targetTransitionDays must be between 1 and 36500 when provided. Current value: ${input.targetTransitionDays}. Use 0 to leave the parameter unset."
  }

  enforce {
    condition     = input.targetExpirationDays <= 0 || (input.targetExpirationDays >= 1 && input.targetExpirationDays <= 36500)
    error_message = "input.targetExpirationDays must be between 1 and 36500 when provided. Current value: ${input.targetExpirationDays}. Use 0 to leave the parameter unset."
  }

  enforce {
    condition     = input.targetTransitionStorageClass == "" || core::contains(local.valid_storage_classes, input.targetTransitionStorageClass)
    error_message = "input.targetTransitionStorageClass must be one of STANDARD_IA, INTELLIGENT_TIERING, ONEZONE_IA, GLACIER, GLACIER_IR, or DEEP_ARCHIVE when provided. Current value: '${input.targetTransitionStorageClass}'. Leave it empty to keep the parameter unset."
  }
}
