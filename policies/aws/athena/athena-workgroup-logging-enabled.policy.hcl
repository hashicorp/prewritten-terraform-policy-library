# Copyright IBM Corp. 2026

# Athena workgroups should have logging enabled

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "athena-workgroup-logging-enabled-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_athena_workgroup" "logging_enabled" {
  enforcement_level = input.athena-workgroup-logging-enabled-enforcement-level

  locals {
    # configuration block is optional in Terraform — default to empty list if absent.
    configuration = core::try(attrs.configuration, [])
    has_config    = core::length(local.configuration) > 0

    # The AWS Config rule athena-workgroup-logging-enabled evaluates
    # PublishCloudWatchMetricsEnabled as the logging signal.
    # Default to false — a missing configuration block means logging is not enabled.
    publish_cloudwatch_metrics_enabled = local.has_config ? core::try(local.configuration[0].publish_cloudwatch_metrics_enabled, false) : false
  }

  enforce {
    condition     = local.publish_cloudwatch_metrics_enabled
    error_message = "Athena workgroup does not have logging enabled. Set configuration.publish_cloudwatch_metrics_enabled = true to enable CloudWatch metrics logging for this workgroup."
  }
}
