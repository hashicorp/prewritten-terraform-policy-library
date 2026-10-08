# Copyright IBM Corp. 2026

# S3 general purpose buckets should have Object Lock enabled
policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.68.0, < 7.0.0"
    }
  }
}

input "s3-bucket-should-have-object-lock-enabled-enforcement-level" {
  type    = string
  default = "advisory"
}

input "valid_mode" {
  type    = list(string)
  default = ["GOVERNANCE", "COMPLIANCE"]
}

resource_policy "aws_s3_bucket" "s3_bucket_should_have_object_lock_enabled" {
  enforcement_level = input.s3-bucket-should-have-object-lock-enabled-enforcement-level
  locals {
    bucket_name = core::try(attrs.bucket, "")

    all_lock_configs = core::getresources("aws_s3_bucket_object_lock_configuration", {})

    # Only configs that belong to this bucket
    lock_configs = [
      for c in local.all_lock_configs : c
      if core::try(c.bucket, "") == local.bucket_name && local.bucket_name != ""
    ]

    # A config is compliant when rule[0].default_retention[0].mode is one of input.valid_mode.
    # Guard against missing rule block, missing default_retention, and null mode.
    compliant_configs = [
      for c in local.lock_configs : c
      if core::length(core::try(c.rule, [])) > 0
      && core::length(core::try(c.rule[0].default_retention, [])) > 0
      && core::try(c.rule[0].default_retention[0].mode, null) != null
      && core::contains(input.valid_mode, c.rule[0].default_retention[0].mode)
    ]
  }

  enforce {
    condition     = core::length(local.compliant_configs) > 0
    error_message = "S3 Buckets should have object lock enabled"
  }
}
