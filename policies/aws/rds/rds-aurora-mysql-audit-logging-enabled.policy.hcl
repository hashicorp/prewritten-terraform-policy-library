# Copyright IBM Corp. 2026

# RDS.34 - Aurora MySQL DB clusters should publish audit logs to CloudWatch Logs.

policy {}

input "rds-aurora-mysql-audit-logging-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_rds_cluster" "aurora_mysql_audit_logging" {
    enforcement_level = input.rds-aurora-mysql-audit-logging-enabled-enforcement-level
    filter = core::try(attrs.engine, "") == "aurora-mysql"

    locals {
        log_exports = core::try(attrs.enabled_cloudwatch_logs_exports, [])
    }

    enforce {
        condition = core::contains(local.log_exports, "audit")
        error_message = "Aurora MySQL DB cluster does not have CloudWatch Logs export enabled for 'audit' logs. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-34 for more details."
    }
}
