# Copyright IBM Corp. 2026

# EFS.2 - Amazon EFS volumes should be in backup plans.

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "efs-in-backup-plan-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_efs_file_system" "in_backup_plan" {
  enforcement_level = input.efs-in-backup-plan-enforcement-level
  locals {
    all_selections = core::getresources("aws_backup_selection", {})
    efs_arn = core::try(attrs.arn, "")
    backup_tag = core::try(attrs.tags["Backup"], "")
    has_backup_tag = local.backup_tag == "true"
    in_backup = core::length([for sel in local.all_selections : sel if core::contains(core::try(sel.resources, []), local.efs_arn)]) > 0
  }

  filter = !local.in_backup && !local.has_backup_tag

  connected "aws_efs_backup_policy" {
    connection {
      subject   = "id"
      connected = "file_system_id"
    }

    filter        = core::try(connected.aws_efs_backup_policy.backup_policy.status, "DISABLED") == "ENABLED"
    min_instances = 1
  }
}
