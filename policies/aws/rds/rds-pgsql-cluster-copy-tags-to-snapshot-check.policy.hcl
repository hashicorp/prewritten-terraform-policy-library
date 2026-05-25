# RDS.47 - RDS for PostgreSQL DB clusters should be configured to copy tags to DB snapshots.

policy {}

resource_policy "aws_rds_cluster" "copy_tags_to_snapshot_enabled" {
    filter = core::contains(["aurora-postgresql"], attrs.engine)

    enforce {
        condition = core::try(attrs.copy_tags_to_snapshot, false) == true
        error_message = "RDS PostgreSQL DB cluster does not have copy_tags_to_snapshot enabled. Set 'copy_tags_to_snapshot = true' to ensure tags are automatically copied to snapshots for proper resource tracking and governance. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-47 for more details."
    }
}
