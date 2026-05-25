# RDS.16 - Aurora DB clusters should be configured to copy tags to DB snapshots.

policy {}

resource_policy "aws_rds_cluster" "copy_tags_to_snapshots_enabled" {
    enforce {
        condition = core::try(attrs.copy_tags_to_snapshot, false)
        error_message = "Aurora DB clusters should be configured to copy tags to DB snapshots. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-16 for more details."
    }
}
