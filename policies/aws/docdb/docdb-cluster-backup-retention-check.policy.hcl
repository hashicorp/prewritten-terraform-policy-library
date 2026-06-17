# DocumentDB.2 - Amazon DocumentDB clusters should have an adequate backup retention period.

policy {}

input "docdb-cluster-backup-retention-check-enforcement-level" {
  type = string
  default = "advisory"
}

input "min_backup_retention_period" {
    type = number
    default = 7
}

resource_policy "aws_docdb_cluster" "backup-retention-period" {
    enforcement_level = input.docdb-cluster-backup-retention-check-enforcement-level
    enforce {
        condition = input.min_backup_retention_period >= 1 && input.min_backup_retention_period <= 35 && core::try(attrs.backup_retention_period, 1) >= input.min_backup_retention_period
        error_message = "The backup retention period for the DocumentDB cluster is less than the minimum required. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/documentdb-controls.html#documentdb-2 for more details."
    }
}