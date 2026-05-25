<<<<<<< HEAD
// SSM.6 - SSM Automation CloudWatch Logging Required

policy {}

// Validate SSM service settings have non-empty values
=======
# SSM.6 - SSM Automation CloudWatch Logging Required

policy {}

# Validate SSM service settings have non-empty values
>>>>>>> origin/main
resource_policy "aws_ssm_service_setting" "automation_logging_settings" {
  locals {
    setting_id = core::try(attrs.setting_id, "")
    setting_value = core::try(attrs.setting_value, "")
    has_value = local.setting_value != "" && local.setting_value != null
  }

  enforce {
    condition = local.has_value
    error_message = "SSM service setting '${local.setting_id}' must have a non-empty value configured. For SSM Automation logging, ensure customer-script-log-destination is 'CloudWatch' and customer-script-log-group-name is set. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ssm-controls.html#ssm-6 for more details."
  }
}

<<<<<<< HEAD
// Validate that CloudWatch log groups have valid names
=======
# Validate that CloudWatch log groups have valid names
>>>>>>> origin/main
resource_policy "aws_cloudwatch_log_group" "log_group_name_required" {
  locals {
    log_group_name = core::try(attrs.name, "")
    has_name = local.log_group_name != "" && local.log_group_name != null
  }

  enforce {
    condition = local.has_name
    error_message = "CloudWatch log group must have a valid name configured. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ssm-controls.html#ssm-6 for more details."
  }
}
