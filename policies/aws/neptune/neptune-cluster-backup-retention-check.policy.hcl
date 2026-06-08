# Copyright IBM Corp. 2026

# Neptune.5 - Neptune DB clusters should have automated backups enabled.

policy {}

input "min_backup_retention_period" {
    type = number
    default = 7
}

resource_policy "aws_neptune_cluster" "backup-retention-period" {
    enforce {
        condition = input.min_backup_retention_period >= 1 && input.min_backup_retention_period <= 35 && core::try(attrs.backup_retention_period, 1) >= input.min_backup_retention_period
        error_message = "The backup retention period for the Neptune cluster is less than the minimum required. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/neptune-controls.html#neptune-5 for more details."
    }
}