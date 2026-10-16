# Copyright IBM Corp. 2026

# DynamoDB tables should be encrypted with AWS KMS keys

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "dynamo-db-table-encrypted-kms-enforcement-level" {
  type    = string
  default = "advisory"
}

# Converted from Sentinel policy: dynamo-db-table-encrypted-kms.sentinel
# This policy verifies that AWS DynamoDB tables are encrypted with AWS KMS.
# It checks the `server_side_encryption` block to ensure KMS encryption is enabled,
# and optionally restricts encryption to a specific set of allowed KMS key ARNs.

input "dynamo-db-table-encrypted-kms-kms_key_arns" {
  type    = list(string)
  default = []
}

resource_policy "aws_dynamodb_table" "dynamo_db_table_encrypted_kms" {
  locals {
    # server_side_encryption is a list-nesting block (max_items = 1); treat as a list.
    sse_raw  = core::try(attrs.server_side_encryption, null)
    sse_list = local.sse_raw != null ? local.sse_raw : []
    has_sse  = core::length(local.sse_list) > 0

    enabled_raw = local.has_sse ? core::try(local.sse_list[0].enabled, null) : null
    enabled     = local.enabled_raw == null ? false : local.enabled_raw

    kms_key_raw = local.has_sse ? core::try(local.sse_list[0].kms_key_arn, null) : null
    kms_key_arn = local.kms_key_raw == null ? "" : local.kms_key_raw

    allowed_keys          = input.dynamo-db-table-encrypted-kms-kms_key_arns
    has_allowed_keys      = core::length(local.allowed_keys) > 0
    allowed_keys_display   = core::join(", ", local.allowed_keys)

    # When no allowed list is supplied, enabled = true is sufficient (provider defaults to
    # the AWS-managed DynamoDB key when kms_key_arn is omitted).
    key_allowed         = local.has_allowed_keys ? core::contains(local.allowed_keys, local.kms_key_arn) : true
    key_in_allowed_list = local.kms_key_arn != "" ? local.key_allowed : false

    is_compliant = local.enabled != true ? false : (local.has_allowed_keys ? local.key_in_allowed_list : true)

    msg_no_sse_with_allowed    = "DynamoDB table must have 'server_side_encryption.enabled' set to true and use one of the allowed KMS keys: ${local.allowed_keys_display}"
    msg_no_sse_without_allowed = "DynamoDB table must have 'server_side_encryption.enabled' set to true so the table uses AWS KMS encryption instead of the default AWS-owned key"
    msg_no_sse                 = local.has_allowed_keys ? local.msg_no_sse_with_allowed : local.msg_no_sse_without_allowed

    msg_not_enabled = "DynamoDB table must have 'server_side_encryption.enabled' set to true to use AWS KMS encryption"

    msg_default_key_restricted = "DynamoDB table is encrypted with the default KMS-managed key, but the rule parameter 'kmsKeyArns' restricts encryption to these allowed keys: ${local.allowed_keys_display}. Set 'kms_key_arn' to one of the allowed keys"
    msg_key_not_allowed         = "DynamoDB table is using KMS key '${local.kms_key_arn}' which is not in the allowed list. Allowed keys: ${local.allowed_keys_display}"
    msg_key_mismatch            = local.kms_key_arn == "" ? local.msg_default_key_restricted : local.msg_key_not_allowed

    msg_when_enabled = local.has_allowed_keys ? local.msg_key_mismatch : local.msg_not_enabled
    msg_when_sse     = local.enabled != true ? local.msg_not_enabled : local.msg_when_enabled

    error_message = local.has_sse ? local.msg_when_sse : local.msg_no_sse
  }

  enforcement_level = input.dynamo-db-table-encrypted-kms-enforcement-level
  enforce {
    condition     = local.is_compliant
    error_message = local.error_message
  }
}
