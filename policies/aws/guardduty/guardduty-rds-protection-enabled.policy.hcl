# Copyright IBM Corp. 2026

# GuardDuty.9 - GuardDuty RDS Protection should be enabled.

policy {}

input "guardduty-rds-protection-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_guardduty_detector_feature" "rds_feature_validation" {
  enforcement_level = input.guardduty-rds-protection-enabled-enforcement-level
  filter = attrs.name == "RDS_LOGIN_EVENTS"

  enforce {
    condition = core::try(attrs.status, "DISABLED") == "ENABLED"
    error_message = "GuardDuty RDS Protection feature must have status='ENABLED'. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/guardduty-controls.html#guardduty-9 for more details."
  }
}

resource_policy "aws_guardduty_organization_configuration_feature" "rds_feature_org_enabled" {
    enforcement_level = input.guardduty-rds-protection-enabled-enforcement-level
    filter = attrs.name == "RDS_LOGIN_EVENTS"

    enforce {
        condition = core::try(attrs.auto_enable, "NONE") == "ALL"
        error_message = "GuardDuty RDS Protection feature does not have RDS_LOGIN_EVENTS properly configured for member accounts. Set auto_enable = 'ALL' to enable for all existing and new member accounts. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/guardduty-controls.html#guardduty-9 for more details."
    }
}
