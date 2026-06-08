# Copyright IBM Corp. 2026

# EFS.1 - Elastic File System Encryption at Rest

policy {}

resource_policy "aws_efs_file_system" "encryption_required" {
    enforce {
        condition     = core::try(attrs.encrypted, false)
        error_message = "EFS file system must have encryption at rest enabled. Set 'encrypted = true' in the resource configuration. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/efs-controls.html#efs-1 for more details."
    }
}