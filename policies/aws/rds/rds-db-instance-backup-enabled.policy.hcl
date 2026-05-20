# RDS.11 - RDS instances should have automatic backups enabled.

policy {}

input "min_backup_retention" {
    type = number
    default = 7
}

resource_policy "aws_db_instance" "backup_enabled" {
    locals {
        backup_period = core::try(attrs.backup_retention_period, 0)
        is_valid_input = input.min_backup_retention >= 7 && input.min_backup_retention <= 35
    }

    enforce {
        condition = local.backup_period != 0 && local.is_valid_input && local.backup_period >= input.min_backup_retention
        error_message = "RDS instances should have automatic backups enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-11 for more details."
    }
}
