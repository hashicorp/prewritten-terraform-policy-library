# RDS.36 - RDS for PostgreSQL DB instances should publish logs to CloudWatch Logs.

policy {}

resource_policy "aws_db_instance" "postgresql_cloudwatch_logs" {
    filter = core::try(attrs.engine, "") == "postgres"

    locals {
        log_exports = core::try(attrs.enabled_cloudwatch_logs_exports, [])
        postgresql_logging_enabled = core::contains(local.log_exports, "postgresql")
        upgrade_logging_enabled = core::contains(local.log_exports, "upgrade")
    }

    enforce {
        condition = local.postgresql_logging_enabled && local.upgrade_logging_enabled
        error_message = "RDS PostgreSQL instance does not have CloudWatch Logs export enabled for both 'postgresql' and 'upgrade' logs. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-36 for more details."
    }
}
