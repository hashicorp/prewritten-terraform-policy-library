# GuardDuty.6 - GuardDuty Lambda Protection should be enabled.

policy {}

input "guardduty-lambda-protection-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_guardduty_detector_feature" "lambda_protection_enabled" {
    enforcement_level = input.guardduty-lambda-protection-enabled-enforcement-level
    filter = attrs.name == "LAMBDA_NETWORK_LOGS"

    enforce {
        condition = core::try(attrs.status, "DISABLED") == "ENABLED"
        error_message = "GuardDuty Lambda Protection (LAMBDA_NETWORK_LOGS) is not enabled for detector. Set status = 'ENABLED' to enable Lambda Protection and monitor Lambda network activity for potential security threats. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/guardduty-controls.html#guardduty-6 for more details."
    }
}

resource_policy "aws_guardduty_organization_configuration_feature" "lambda_protection_org_enabled" {
    enforcement_level = input.guardduty-lambda-protection-enabled-enforcement-level
    filter = attrs.name == "LAMBDA_NETWORK_LOGS"

    enforce {
        condition = core::try(attrs.auto_enable, "NONE") == "ALL"
        error_message = "GuardDuty organization configuration feature does not have Lambda Protection (LAMBDA_NETWORK_LOGS) properly configured for member accounts. Set auto_enable = 'ALL' to enable for all existing and new member accounts. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/guardduty-controls.html#guardduty-6 for more details."
    }
}
