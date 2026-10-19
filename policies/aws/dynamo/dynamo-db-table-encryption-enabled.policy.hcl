# Copyright IBM Corp. 2026

# DynamoDB tables should be encrypted at rest

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "dynamo-db-table-encryption-enabled-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_dynamodb_table" "dynamo_db_table_encryption_enabled" {
  locals {
    sse_raw      = core::try(attrs.server_side_encryption, null)
    sse_blocks   = local.sse_raw != null ? local.sse_raw : []
    enabled_raw  = core::length(local.sse_blocks) > 0 ? core::try(local.sse_blocks[0].enabled, null) : null
    key_type     = local.enabled_raw == true ? "AWS KMS key" : "AWS owned key"
    is_encrypted = true
  }

  enforcement_level = input.dynamo-db-table-encryption-enabled-enforcement-level

  enforce {
    condition     = local.is_encrypted
    error_message = "DynamoDB table '${core::try(attrs.name, "")}' must be encrypted at rest (current encryption: ${local.key_type})."
  }
}
