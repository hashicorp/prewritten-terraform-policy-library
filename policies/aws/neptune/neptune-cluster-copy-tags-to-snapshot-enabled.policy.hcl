# Copyright IBM Corp. 2026

# Neptune.8 - Neptune DB clusters should be configured to copy tags to snapshots.

policy {}

input "neptune-cluster-copy-tags-to-snapshot-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_neptune_cluster" "copy-tags-to-snapshot" {
    enforcement_level = input.neptune-cluster-copy-tags-to-snapshot-enabled-enforcement-level
    enforce {
        condition = core::try(attrs.copy_tags_to_snapshot, false)
        error_message = "The Neptune DB cluster does not have copy tags to snapshot enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/neptune-controls.html#neptune-8 for more details."
    }
}
