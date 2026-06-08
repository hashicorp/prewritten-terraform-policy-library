# Copyright IBM Corp. 2026

# Neptune.6 - Neptune DB cluster snapshots should be encrypted at rest

policy {}

resource_policy "aws_neptune_cluster_snapshot" "snapshot-encrypted" {
    enforce {
        condition = core::try(attrs.storage_encrypted, false)
        error_message = "The Neptune cluster snapshot is not encrypted at rest. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/neptune-controls.html#neptune-6 for more details."
    }
}
