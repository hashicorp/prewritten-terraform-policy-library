# Copyright IBM Corp. 2026

# IAM principals should not have IAM inline policies that allow decryption actions on all KMS keys
#
# NOTE: This policy uses exact string matching for blocked actions. Wildcard patterns (e.g., kms:*) are NOT supported.
# Users must explicitly list all blocked actions in the CSV format.
# Example: "kms:Decrypt,kms:ReEncryptFrom,kms:ReEncryptTo,kms:*"

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "iam-inline-policy-blocked-kms-actions-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_iam_policy_document" "kms_restrict_decrypt_actions" {
  enforcement_level = input.iam-inline-policy-blocked-kms-actions-enforcement-level
  locals {
    statements = core::try(attrs.statement, [])

    statements_with_blocked_actions = [
      for stmt in local.statements : stmt
      if core::length([for action in core::try(stmt.actions, []) : action if action == "kms:ReEncryptFrom" || action == "kms:Decrypt"]) > 0
    ]

    no_blocked_actions = core::length(local.statements_with_blocked_actions) == 0
  }

  enforce {
    condition     = local.no_blocked_actions
    error_message = "Actions 'kms:ReEncryptFrom' and 'kms:Decrypt' must not be allowed on all 'KMS keys'."
  }
}
