# Copyright IBM Corp. 2026

# Backup.1 - AWS Backup recovery points should be encrypted at rest.

policy {}

input "backup-recovery-point-encrypted-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_backup_framework" "encrypted" {
    enforcement_level = input.backup-recovery-point-encrypted-enforcement-level
    enforce {
        condition = core::try(attrs.control.name, "") == "BACKUP_RECOVERY_POINT_ENCRYPTED"
        error_message = "AWS Backup recovery point is not encrypted. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/backup-controls.html#backup-1 for more details."
    }
}
