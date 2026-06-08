# Copyright IBM Corp. 2026

# FSx.1 - FSx for OpenZFS file systems should be configured to copy tags to backups and volumes

policy {}

resource_policy "aws_fsx_openzfs_file_system" "copy_tags_enabled" {
    enforce {
        condition = core::try(attrs.copy_tags_to_backups, false) && core::try(attrs.copy_tags_to_volumes, false)
        error_message = "FSx for OpenZFS file system must be configured to copy tags to backups and volumes. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/fsx-controls.html#fsx-1 for more details."
    }
}
