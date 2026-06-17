# Copyright IBM Corp. 2026

# RDS.16 - Aurora DB clusters should be configured to copy tags to DB snapshots.

policy {}

input "rds-cluster-copy-tags-to-snapshots-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_rds_cluster" "copy_tags_to_snapshots_enabled" {
    enforcement_level = input.rds-cluster-copy-tags-to-snapshots-enabled-enforcement-level
    enforce {
        condition = core::try(attrs.copy_tags_to_snapshot, false)
        error_message = "Aurora DB clusters should be configured to copy tags to DB snapshots. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-16 for more details."
    }
}
