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

input "mode" {
  type    = list(string)
  default = []
}

resource_policy "aws_s3_bucket" "s3_bucket_should_have_object_lock_enabled" {
  enforcement_level = input.s3-bucket-should-have-object-lock-enabled-enforcement-level
  locals {
    bucket_name = core::try(attrs.bucket, "")
    is_enabled  = core::try(attrs.object_lock_enabled, false) == true

    lock_configs = core::getresources("aws_s3_bucket_object_lock_configuration", {
      bucket = local.bucket_name
    })
    has_lock_config = core::length(local.lock_configs) > 0
    lock_config     = local.has_lock_config ? [for c in local.lock_configs : c][0] : null
    rules_raw       = local.lock_config != null ? core::try(local.lock_config.rule, null) : null
    rules           = local.rules_raw != null ? local.rules_raw : []
    rule            = core::length(local.rules) > 0 ? [for r in local.rules : r][0] : null
    retention_raw   = local.rule != null ? core::try(local.rule.default_retention, null) : null
    retention       = local.retention_raw != null ? local.retention_raw : []
    retention_block = core::length(local.retention) > 0 ? [for r in local.retention : r][0] : null
    retention_mode  = local.retention_block != null ? core::try(local.retention_block.mode, null) : null

    mode_is_compliant = (
      core::length(input.mode) == 0
      ? true
      : local.retention_mode != null
      ? core::contains(input.mode, local.retention_mode)
      : false
    )
    is_compliant = local.is_enabled && local.mode_is_compliant
  }

  enforce {
    condition     = local.is_compliant
    error_message = "S3 Buckets should have object lock enabled and match the configured mode, when specified"
  }
}
