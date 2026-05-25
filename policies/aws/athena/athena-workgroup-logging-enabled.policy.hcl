# Athena.4 - Athena workgroups should have logging enabled.

policy {}

resource_policy "aws_athena_workgroup" "logging-enabled" {
    enforce {
        condition = core::try(attrs.configuration[0].publish_cloudwatch_metrics_enabled, true)
        error_message = "Athena workgroup does not have logging enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/athena-controls.html#athena-4 for more details."
    }
}
