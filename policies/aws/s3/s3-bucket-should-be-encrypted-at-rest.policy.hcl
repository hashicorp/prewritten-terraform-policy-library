# Copyright IBM Corp. 2026

# S3 general purpose buckets should be encrypted at rest with AWS KMS keys

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.68.0, < 7.0.0"
    }
  }
}

input "s3-bucket-should-be-encrypted-at-rest-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_s3_bucket" "s3_bucket_should_be_encrypted_at_rest" {
  enforcement_level = input.s3-bucket-should-be-encrypted-at-rest-enforcement-level
  locals {
    bucket_name = core::try(attrs.bucket, "")
    encryption_configs = core::getresources("aws_s3_bucket_server_side_encryption_configuration", {
      bucket = local.bucket_name
    })

    has_encryption_config = core::length(local.encryption_configs) > 0
    encryption_config    = local.has_encryption_config ? [for c in local.encryption_configs : c][0] : null
    rules_raw            = local.encryption_config != null ? core::try(local.encryption_config.rule, null) : null
    rules                = local.rules_raw != null ? local.rules_raw : []
    rule                 = core::length(local.rules) > 0 ? [for r in local.rules : r][0] : null
    apply_blocks_raw     = local.rule != null ? core::try(local.rule.apply_server_side_encryption_by_default, null) : null
    apply_blocks         = local.apply_blocks_raw != null ? local.apply_blocks_raw : []
    apply_block          = core::length(local.apply_blocks) > 0 ? [for a in local.apply_blocks : a][0] : null
    sse_algorithm        = local.apply_block != null ? core::try(local.apply_block.sse_algorithm, null) : null

    is_compliant = local.sse_algorithm != null ? core::contains(["aws:kms", "aws:kms:dsse"], local.sse_algorithm) : false
  }

  enforce {
    condition     = local.is_compliant
    error_message = "S3 Buckets should have encryption enabled at rest with AWS KMS"
  }
}
