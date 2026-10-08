# Copyright IBM Corp. 2026

#  S3 general purpose buckets should be encrypted at rest with AWS KMS keys
policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.65.0, < 7.0.0"
    }
  }
}

input "s3-bucket-should-be-encrypted-at-rest-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_s3_bucket" "encrypted_at_rest_with_kms" {
  locals {
    encryption_configs = core::getresources("aws_s3_bucket_server_side_encryption_configuration", {
      bucket = attrs.id
    })

    # One entry per encryption configuration: true when it uses a customer/AWS KMS key correctly
    compliant_flags = [
      for c in local.encryption_configs : (
        core::length(core::try(c.rule, [])) > 0 &&
        core::length(core::try(c.rule[0].apply_server_side_encryption_by_default, [])) > 0 &&
        core::try(c.rule[0].apply_server_side_encryption_by_default[0].sse_algorithm, null) != null &&
        core::try(c.rule[0].apply_server_side_encryption_by_default[0].sse_algorithm, "") != "" &&
        core::try(c.rule[0].apply_server_side_encryption_by_default[0].sse_algorithm, "") != "AES256" &&
        core::try(c.rule[0].apply_server_side_encryption_by_default[0].kms_master_key_id, null) != null &&
        core::try(c.rule[0].apply_server_side_encryption_by_default[0].kms_master_key_id, "") != "" &&
        core::try(c.rule[0].apply_server_side_encryption_by_default[0].kms_master_key_id, "") != "aws/s3"
      )
    ]

    has_compliant_config = core::length([for f in local.compliant_flags : f if f]) > 0
  }

  enforcement_level = input.s3-bucket-should-be-encrypted-at-rest-enforcement-level
  enforce {
    condition     = local.has_compliant_config
    error_message = "S3 Buckets should have encryption enabled at rest with AWS KMS Key"
  }
}

