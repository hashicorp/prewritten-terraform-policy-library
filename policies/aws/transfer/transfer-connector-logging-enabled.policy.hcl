// Policy: Transfer.3 - Transfer Family connectors should have logging enabled

policy {}

resource_policy "aws_transfer_connector" "logging_enabled" {
    locals {
        // Safe access to logging_role attribute with null fallback
        logging_role = core::try(attrs.logging_role, null)
        
        // Check if logging_role is configured (not null and not empty string)
        has_logging_role = local.logging_role != null && local.logging_role != ""
    }

    enforce {
        condition     = local.has_logging_role
        error_message = "Transfer Family connector must have CloudWatch logging enabled. Configure the 'logging_role' attribute with a valid IAM role ARN that has permissions to write to CloudWatch Logs. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/transfer-controls.html#transfer-3 for more details."
    }
}
