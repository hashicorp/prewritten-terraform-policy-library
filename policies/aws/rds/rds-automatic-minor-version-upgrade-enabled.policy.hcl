# Copyright IBM Corp. 2026

# RDS.13 - RDS automatic minor version upgrades should be enabled

policy {}

resource_policy "aws_db_instance" "automatic_minor_version_upgrade_enabled" {
    enforce {
        condition = core::try(attrs.auto_minor_version_upgrade, true)
        error_message = "RDS automatic minor version upgrades should be enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-13 for more details."
    }
}
