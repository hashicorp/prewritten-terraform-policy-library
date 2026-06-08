# Copyright IBM Corp. 2026

# RDS.48 - RDS for MySQL DB clusters should be configured to copy tags to DB snapshots.

policy {}

resource_policy "aws_rds_cluster" "copy_mysql_tags_to_snapshot_enabled" {
    filter = core::try(attrs.engine, "") == "aurora-mysql"

    enforce {
        condition = core::try(attrs.copy_tags_to_snapshot, false) == true
        error_message = "RDS MySQL cluster does not have copy_tags_to_snapshot enabled. Set 'copy_tags_to_snapshot = true' to automatically copy tags to DB snapshots for proper resource tracking and governance. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-48 for more details."
    }
}
