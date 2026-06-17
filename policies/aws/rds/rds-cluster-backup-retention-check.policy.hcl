# Copyright IBM Corp. 2026

# RDS.50 - RDS DB clusters should have enough backup retention period set.

policy {}

input "rds-cluster-backup-retention-check-enforcement-level" {
  type = string
  default = "advisory"
}

input "min_backup_retention_period" {
    type = number
    default = 7
}

resource_policy "aws_rds_cluster" "cluster_backup_enabled" {
    enforcement_level = input.rds-cluster-backup-retention-check-enforcement-level
    locals {
        backup_period = core::try(attrs.backup_retention_period, 1)
        is_valid_input = input.min_backup_retention_period >= 7 && input.min_backup_retention_period <= 35
    }

    enforce {
        condition = local.backup_period != 0 && local.is_valid_input && local.backup_period >= input.min_backup_retention_period
        error_message = "RDS clusters should have enough backup retention period set. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-50 for more details."
    }
}
