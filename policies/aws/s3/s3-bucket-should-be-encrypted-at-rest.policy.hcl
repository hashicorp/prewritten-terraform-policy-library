# Copyright IBM Corp. 2026

#  S3 general purpose buckets should be encrypted at rest with AWS KMS keys

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

    all_enc_configs = core::getresources("aws_s3_bucket_server_side_encryption_configuration", {})

    # Only configs that belong to this bucket
    encryption_configs = [
      for c in local.all_enc_configs : c
      if core::try(c.bucket, "") == local.bucket_name && local.bucket_name != ""
    ]

    # One entry per linked configuration: true when it uses a customer-specified KMS key.
    config_compliance = [
      for c in local.encryption_configs : (
        core::try(c.rule[0].apply_server_side_encryption_by_default[0].sse_algorithm, null) != null
        && core::try(c.rule[0].apply_server_side_encryption_by_default[0].sse_algorithm, "") != ""
        && core::try(c.rule[0].apply_server_side_encryption_by_default[0].sse_algorithm, "") != "AES256"
        && core::try(c.rule[0].apply_server_side_encryption_by_default[0].kms_master_key_id, null) != null
        && core::try(c.rule[0].apply_server_side_encryption_by_default[0].kms_master_key_id, "") != ""
        && core::try(c.rule[0].apply_server_side_encryption_by_default[0].kms_master_key_id, "") != "aws/s3"
      )
    ]

    has_compliant_config = core::length([for ok in local.config_compliance : ok if ok]) > 0
  }

  enforce {
    condition     = local.has_compliant_config
    error_message = "S3 Buckets should have encryption enabled at rest with AWS KMS Key"
  }
}
