# Copyright IBM Corp. 2026

# Secrets Manager secrets should be encrypted with customer managed AWS KMS keys

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "secretsmanager-secrets-encrypted-using-cmk-enforcement-level" {
  type    = string
  default = "advisory"
}

input "secretsmanager-secrets-encrypted-using-cmk-allowed_kms_key_arns" {
  type    = list(string)
  default = []
}

resource_policy "aws_secretsmanager_secret" "secretsmanager_secrets_encrypted_using_cmk" {
  locals {
    kms_key_id_raw = core::try(attrs.kms_key_id, null)
    kms_key_id     = local.kms_key_id_raw == null ? "" : local.kms_key_id_raw

    is_configured = local.kms_key_id != ""

    is_aws_managed_key = local.kms_key_id == "alias/aws/secretsmanager" || local.kms_key_id == "aws/secretsmanager" || core::startswith(local.kms_key_id, "alias/aws/secretsmanager")

    allowed_arns  = input.secretsmanager-secrets-encrypted-using-cmk-allowed_kms_key_arns
    has_allowlist = core::length(local.allowed_arns) > 0

    matched_allowed_arns = [for arn in local.allowed_arns : arn
    if local.kms_key_id == arn || core::endswith(arn, local.kms_key_id)]

    matches_allowlist = core::length(local.matched_allowed_arns) > 0
    is_allowed_key    = !local.has_allowlist || local.matches_allowlist
  }

  enforcement_level = input.secretsmanager-secrets-encrypted-using-cmk-enforcement-level
  enforce {
    condition     = local.is_configured
    error_message = "Secrets Manager secret must be encrypted with a customer managed KMS key (CMK). The 'kms_key_id' attribute is not specified, which means it uses the AWS managed key (aws/secretsmanager)."
  }

  enforce {
    condition     = !local.is_aws_managed_key
    error_message = "Secrets Manager secret is using AWS managed key '${local.kms_key_id}'. The rule is NON_COMPLIANT when using aws/secretsmanager. It must use a customer managed KMS key (CMK) instead."
  }

  enforce {
    condition     = local.is_allowed_key
    error_message = "Secrets Manager secret is using KMS key '${local.kms_key_id}' which is not in the allowed list of KMS key ARNs (input.secretsmanager-secrets-encrypted-using-cmk-allowed_kms_key_arns)."
  }
}
