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

# Ensure AWS Secrets Manager secrets are encrypted using a customer managed KMS key (CMK)
#
# Converted from Sentinel policy: secretsmanager-secrets-encrypted-using-cmk.sentinel
# A secret is non-compliant when:
#   - kms_key_id is not set (Secrets Manager defaults to the AWS managed key aws/secretsmanager), or
#   - kms_key_id references the AWS managed key (by alias "alias/aws/secretsmanager", the bare
#     name "aws/secretsmanager", or any value prefixed with "alias/aws/secretsmanager"), or
#   - an allowlist of KMS key ARNs (input.secretsmanager-secrets-encrypted-using-cmk-allowed_kms_key_arns) is configured and the secret's
#     kms_key_id does not match any entry in that allowlist (matching either the full value or
#     the key-id suffix of an allowed ARN, mirroring the Sentinel `is_allowed_kms_key` helper)
#
# NOTE: The Sentinel `kmsKeyArns` param is a comma-separated string that is parsed into a list
# at evaluation time. tfpolicy expresses this directly as a list(string) input
# (`allowed_kms_key_arns`) instead of a comma-separated string, since tfpolicy inputs support
# native list types. An empty list preserves the Sentinel default behavior: "any customer
# managed key is allowed".
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

    # A kms_key_id matches the allowlist when it equals an allowed ARN exactly, or when the
    # allowed ARN ends with the kms_key_id (handles key-id-only / alias-only values), mirroring
    # Sentinel's is_allowed_kms_key() helper.
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
