# Policy: Connect.2 - Amazon Connect instances should have CloudWatch logging enabled

policy {}

resource_policy "aws_connect_instance" "cloudwatch_logging_enabled" {
    locals {
        // Safely access the contact_flow_logs_enabled attribute with default false
        contact_flow_logs_enabled = core::try(attrs.contact_flow_logs_enabled, false)
    }

    enforce {
        condition     = local.contact_flow_logs_enabled == true
        error_message = "Amazon Connect instance must have contact flow logs enabled. Set 'contact_flow_logs_enabled = true' to enable CloudWatch logging for contact flows. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/connect-controls.html#connect-2 for more details."
    }
}
