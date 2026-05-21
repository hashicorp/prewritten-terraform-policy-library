# Neptune.2 - Neptune DB clusters should publish audit logs to CloudWatch Logs.

policy {}

resource_policy "aws_neptune_cluster" "audit-logging-enabled" {
    locals {
        log_enabled = core::try(attrs.enable_cloudwatch_logs_exports, [])
    }

    enforce {
        condition = local.log_enabled != [] && core::contains(local.log_enabled, "audit")
        error_message = "The Neptune cluster does not have audit logging enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/neptune-controls.html#neptune-2 for more details."
    }
}