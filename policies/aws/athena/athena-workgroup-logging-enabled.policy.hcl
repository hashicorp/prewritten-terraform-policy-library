# Copyright IBM Corp. 2026

# Athena.4 - Athena workgroups should have logging enabled.

policy {}

input "athena-workgroup-logging-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_athena_workgroup" "logging-enabled" {
    enforcement_level = input.athena-workgroup-logging-enabled-enforcement-level
    enforce {
        condition = core::try(attrs.configuration[0].publish_cloudwatch_metrics_enabled, true)
        error_message = "Athena workgroup does not have logging enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/athena-controls.html#athena-4 for more details."
    }
}
