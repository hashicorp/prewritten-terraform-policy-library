# RDS.9 - RDS DB instances should publish logs to CloudWatch Logs.

policy {}

resource_policy "aws_db_instance" "rds_logging_enabled" {
    locals {
        engine = core::try(attrs.engine, "")
        enabled_logs = core::try(attrs.enabled_cloudwatch_logs_exports, [])

        required_logs = local.engine == "oracle-ee" || local.engine == "oracle-ee-cdb" || local.engine == "oracle-se2" || local.engine == "oracle-se2-cdb" ? ["alert", "audit", "trace", "listener"] : local.engine == "postgres" ? ["postgresql", "upgrade"] : local.engine == "mysql" ? ["audit", "error", "general", "slowquery"] : local.engine == "mariadb" ? ["audit", "error", "general", "slowquery"] : local.engine == "sqlserver-ee" || local.engine == "sqlserver-ex" || local.engine == "sqlserver-se" || local.engine == "sqlserver-web" ? ["error", "agent"] : []

        missing_logs = [
            for required_log in local.required_logs :
            required_log if !core::contains(local.enabled_logs, required_log)
        ]
    }

    enforce {
        condition = core::length(local.required_logs) == 0 || core::length(local.missing_logs) == 0
        error_message = "RDS DB instance must enable all required CloudWatch log exports for engine '${local.engine}'. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-9 for more details."
    }
}
