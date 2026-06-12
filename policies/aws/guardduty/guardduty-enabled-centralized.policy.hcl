# GuardDuty.1 - GuardDuty should be enabled.

policy {}

input "guardduty-enabled-centralized-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_guardduty_detector" "guardduty_enabled" {
    enforcement_level = input.guardduty-enabled-centralized-enforcement-level
    enforce {
        condition = core::try(attrs.enable, true) == true
        error_message = "GuardDuty detector must be enabled. Set 'enable = true' to enable threat detection and security monitoring. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/guardduty-controls.html#guardduty-1 for more details."
    }
}
