# Neptune.8 - Neptune DB clusters should be configured to copy tags to snapshots.

policy {}

resource_policy "aws_neptune_cluster" "copy-tags-to-snapshot" {
    enforce {
        condition = core::try(attrs.copy_tags_to_snapshot, false)
        error_message = "The Neptune DB cluster does not have copy tags to snapshot enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/neptune-controls.html#neptune-8 for more details."
    }
}
