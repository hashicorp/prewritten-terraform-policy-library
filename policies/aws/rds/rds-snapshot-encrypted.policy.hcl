# RDS.4 - RDS cluster snapshots and database snapshots should be encrypted at rest.

policy {}

input "rds-snapshot-encrypted-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_db_snapshot" "snapshot_encrypted" {
    enforcement_level = input.rds-snapshot-encrypted-enforcement-level
    enforce {
        condition = core::try(attrs.encrypted, false)
        error_message = "RDS snapshot is not encrypted at rest. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-4 for more details."
    }
}

resource_policy "aws_db_cluster_snapshot" "cluster_snapshot_encrypted" {
    enforcement_level = input.rds-snapshot-encrypted-enforcement-level
    enforce {
        condition = core::try(attrs.storage_encrypted, false)
        error_message = "RDS cluster snapshot is not encrypted at rest. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-4 for more details."
    }
}
