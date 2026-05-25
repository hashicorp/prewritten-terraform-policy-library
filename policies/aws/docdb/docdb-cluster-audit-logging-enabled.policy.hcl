# DocumentDB.4 - Amazon DocumentDB clusters should publish audit logs to CloudWatch Logs.

policy {}

resource_policy "aws_docdb_cluster" "audit-logging-enabled" {
    locals {
        log_enabled = core::try(attrs.enabled_cloudwatch_logs_exports, [])
    }

    enforce {
        condition = local.log_enabled != [] && core::contains(local.log_enabled, "audit")
        error_message = "The DocumentDB cluster does not have audit logging enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/documentdb-controls.html#documentdb-4 for more details."
    }
}