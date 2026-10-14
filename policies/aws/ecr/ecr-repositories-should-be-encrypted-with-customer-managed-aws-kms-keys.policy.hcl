# Copyright IBM Corp. 2026

# ECR repositories should be encrypted with customer managed AWS KMS keys

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.65.0, < 7.0.0"
    }
  }
}

input "kmsKeyArns" {
  type    = list(string)
  default = []
}

input "ecr-repositories-should-be-encrypted-with-customer-managed-aws-kms-keys-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_ecr_repository" "encrypted_with_customer_managed_kms_key" {
  locals {
    enc_raw         = core::try(attrs.encryption_configuration, null)
    enc_list        = local.enc_raw != null ? local.enc_raw : []
    has_enc         = core::length(local.enc_list) > 0
    enc_type_raw    = local.has_enc ? core::try([for c in local.enc_list : c][0].encryption_type, null) : null
    kms_key_raw     = local.has_enc ? core::try([for c in local.enc_list : c][0].kms_key, null) : null
    is_kms          = local.enc_type_raw != null ? core::contains(["KMS", "KMS_DSSE"], local.enc_type_raw) : false
    has_kms_key     = local.kms_key_raw != null && local.kms_key_raw != ""
    is_aws_managed_alias = local.has_kms_key ? core::length(core::regexall("^alias/aws/", core::lower(local.kms_key_raw))) > 0 : false
    is_allowed_key = (
      core::length(input.kmsKeyArns) == 0
      ? true
      : local.has_kms_key
      ? core::contains(input.kmsKeyArns, local.kms_key_raw)
      : false
    )
    is_compliant = local.has_enc && local.is_kms && local.has_kms_key && !local.is_aws_managed_alias && local.is_allowed_key
  }

  enforcement_level = input.ecr-repositories-should-be-encrypted-with-customer-managed-aws-kms-keys-enforcement-level
  enforce {
    condition     = local.is_compliant
    error_message = "ECR repositories must use a customer-managed KMS or KMS_DSSE key. When configured, the key must be listed in the kmsKeyArns allowlist."
  }
}
