# Copyright IBM Corp. 2026

# FSx.2 - FSx for Lustre file systems should be configured to copy tags to backups.

policy {}

resource_policy "aws_fsx_lustre_file_system" "copy_tags_to_backups" {
    filter = core::try(attrs.deployment_type, "") == "PERSISTENT_1" || core::try(attrs.deployment_type, "") == "PERSISTENT_2"
    enforce {
        condition = core::try(attrs.copy_tags_to_backups, false)
        error_message = "FSx for Lustre file system must be configured to copy tags to backups. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/fsx-controls.html#fsx-2 for more details."
    }
}
