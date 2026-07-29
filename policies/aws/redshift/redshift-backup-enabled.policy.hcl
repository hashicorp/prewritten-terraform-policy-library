# Copyright IBM Corp. 2026

# Redshift.3 - Amazon Redshift clusters should have automatic snapshots enabled. This control checks whether an Amazon Redshift cluster has automated snapshots enabled, and a retention period greater than or equal to the specified time frame.

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0, < 7.0.0"
    }
  }
}

input "redshift-backup-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

input "min_retention_period" {
    type = number
    default = 1
}

input "max_retention_period" {
    type = number
    default = 35
}

resource_policy "aws_redshift_cluster" "redshift-backup-enabled" {
    enforcement_level = input.redshift-backup-enabled-enforcement-level
    locals {
        backup_enabled = core::try(attrs.automated_snapshot_retention_period, 1)
    }

    enforce {
        condition = (local.backup_enabled >= input.min_retention_period) && (local.backup_enabled <= input.max_retention_period) && (local.backup_enabled != 0)
        error_message = "Redshift cluster does not have automated snapshots enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/redshift-controls.html#redshift-3 for more details."
    }
}