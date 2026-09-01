# Copyright IBM Corp. 2026

# AWS Backup recovery points should be encrypted at rest

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.1.0, < 7.0.0"
    }
  }
}

input "backup-recovery-point-encrypted-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_backup_vault" "backup_recovery_point_encrypted" {
  enforcement_level = input.backup-recovery-point-encrypted-enforcement-level

  locals {
    kms_key_arn = core::try(attrs.kms_key_arn, "")
    is_encrypted = local.kms_key_arn != ""
  }

  enforce {
    condition     = local.is_encrypted
    error_message = "AWS Backup vault '${attrs.name}' must have kms_key_arn configured so recovery points are encrypted at rest"
  }
}
