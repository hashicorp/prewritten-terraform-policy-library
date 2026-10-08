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

resource_policy "aws_s3_bucket_object_lock_configuration" "s3_bucket_should_have_object_lock_enabled" {
  enforcement_level = input.s3-bucket-should-have-object-lock-enabled-enforcement-level
  locals {
    rule              = core::try(attrs.rule[0], null)
    default_retention = local.rule != null ? core::try(local.rule.default_retention[0], null) : null
    mode              = local.default_retention != null ? core::try(local.default_retention.mode, null) : null
    is_compliant      = local.mode != null ? core::contains(input.valid_mode, local.mode) : false
  }

  enforce {
    condition     = local.is_compliant
    error_message = "S3 Buckets should have object lock enabled"
  }
}
