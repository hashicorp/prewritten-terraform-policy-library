# Policy: Cognito.6 - Cognito user pools should have deletion protection enabled

policy {}

resource_policy "aws_cognito_user_pool" "deletion_protection_enabled" {
    locals {
        // Safely access deletion_protection attribute with default value "INACTIVE"
        deletion_protection = core::try(attrs.deletion_protection, "INACTIVE")
    }

    enforce {
        condition = local.deletion_protection == "ACTIVE"
        error_message = "Cognito user pool must have deletion protection enabled. Current value: '${local.deletion_protection}'. Set deletion_protection to 'ACTIVE'. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/cognito-controls.html#cognito-6 for more details."
    }
}