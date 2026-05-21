# RDS.17 - RDS DB instances should be configured to copy tags to snapshots.

policy {}

resource_policy "aws_db_instance" "copy_tags_to_snapshots_enabled" {
    enforce {
        condition = core::try(attrs.copy_tags_to_snapshot, false)
        error_message = "RDS instances should be configured to copy tags to DB snapshots. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-17 for more details."
    }
}
