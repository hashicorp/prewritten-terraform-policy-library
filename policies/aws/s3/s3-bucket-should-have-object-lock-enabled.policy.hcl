# Copyright IBM Corp. 2026

# S3 general purpose buckets should have Object Lock enabled
policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.65.0, < 7.0.0"
    }
  }
}

input "valid_mode" {
  type    = list(string)
  default = ["GOVERNANCE", "COMPLIANCE"]
}

resource_policy "aws_s3_bucket" "s3_bucket_should_have_object_lock_enabled" {
  locals {
    lock_configs = core::getresources("aws_s3_bucket_object_lock_configuration", {
      bucket = attrs.id
    })

    # Mode of the first default_retention in the first rule of each associated configuration
    # (mirrors the Sentinel rule_block[0].default_retention[0] access)
    modes = [
      for c in local.lock_configs :
      core::try(c.rule[0].default_retention[0].mode, null) == null ? "" : c.rule[0].default_retention[0].mode
    ]

    valid_modes  = [for m in local.modes : m if m != "" && core::contains(input.valid_mode, m)]
    is_compliant = core::length(local.valid_modes) > 0
  }

  enforcement_level = "advisory"
  enforce {
    condition     = local.is_compliant
    error_message = "S3 Buckets should have object lock enabled"
  }
}

