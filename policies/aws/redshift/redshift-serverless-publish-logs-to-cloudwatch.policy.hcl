# Policy : RedshiftServerless.6 - Redshift Serverless namespaces should export logs to CloudWatch Logs

policy {}

resource_policy "aws_redshiftserverless_namespace" "require_cloudwatch_log_exports" {
    locals {
        log_exports = core::try(attrs.log_exports, [])
        has_connection_log = core::contains(local.log_exports, "connectionlog")
        has_user_log = core::contains(local.log_exports, "userlog")
    }

    enforce {
        condition = local.has_connection_log
        error_message = "Redshift Serverless namespace must export connectionlog to CloudWatch Logs. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/redshiftserverless-controls.html#redshiftserverless-6 for more details."
    }

    enforce {
        condition = local.has_user_log
        error_message = "Redshift Serverless namespace must export userlog to CloudWatch Logs. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/redshiftserverless-controls.html#redshiftserverless-6 for more details."
    }
}
