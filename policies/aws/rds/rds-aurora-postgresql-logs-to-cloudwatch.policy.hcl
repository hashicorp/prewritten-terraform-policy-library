# RDS.37 - Aurora PostgreSQL DB clusters should publish logs to CloudWatch Logs.

policy {}

resource_policy "aws_rds_cluster" "aurora_postgresql_cloudwatch_logs" {
    filter = attrs.engine == "aurora-postgresql"

    locals {
        log_exports = core::try(attrs.enabled_cloudwatch_logs_exports, [])
    }

    enforce {
        condition = core::contains(local.log_exports, "postgresql")
        error_message = "Aurora PostgreSQL cluster does not have 'postgresql' logs enabled for CloudWatch Logs export. Add 'postgresql' to the 'enabled_cloudwatch_logs_exports' attribute to enable centralized logging and monitoring. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-37 for more details."
    }
}
