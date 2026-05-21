# GuardDuty.13 - GuardDuty EC2 Runtime Monitoring should be enabled.

policy {}

resource_policy "aws_guardduty_detector_feature" "ec2_runtime_monitoring_enabled" {
    filter = core::try(attrs.name, "") == "RUNTIME_MONITORING"

    locals {
        feature_status = core::try(attrs.status, "DISABLED")
        additional_config = core::try(attrs.additional_configuration, [])
        has_additional_config = core::length(local.additional_config) > 0
        ec2_agent_configs = local.has_additional_config ? [
            for config in local.additional_config :
            config if core::try(config.name, "") == "EC2_AGENT_MANAGEMENT"
        ] : []
        
        has_ec2_agent_config = core::length(local.ec2_agent_configs) > 0
        ec2_agent_status = local.has_ec2_agent_config ? core::try(local.ec2_agent_configs[0].status, "DISABLED") : "DISABLED"
    }

    enforce {
        condition = local.feature_status == "ENABLED"
        error_message = "GuardDuty RUNTIME_MONITORING feature must be enabled. Set status = 'ENABLED' to enable EC2 runtime monitoring. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/guardduty-controls.html#guardduty-13 for more details."
    }

    enforce {
        condition = local.ec2_agent_status == "ENABLED"
        error_message = "GuardDuty RUNTIME_MONITORING feature must have EC2_AGENT_MANAGEMENT enabled in additional_configuration. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/guardduty-controls.html#guardduty-13 for more details."
    }
}

resource_policy "aws_guardduty_organization_configuration_feature" "ec2_runtime_monitoring_enabled" {
    filter = core::try(attrs.name, "") == "RUNTIME_MONITORING"

    locals {
        feature_status = core::try(attrs.auto_enable, "NONE")
        additional_config = core::try(attrs.additional_configuration, [])
        has_additional_config = core::length(local.additional_config) > 0
        ec2_agent_configs = local.has_additional_config ? [
            for config in local.additional_config :
            config if core::try(config.name, "") == "EC2_AGENT_MANAGEMENT"
        ] : []
        
        has_ec2_agent_config = core::length(local.ec2_agent_configs) > 0
        ec2_agent_status = local.has_ec2_agent_config ? core::try(local.ec2_agent_configs[0].auto_enable, "NONE") : "NONE"
    }

    enforce {
        condition = local.feature_status == "ALL"
        error_message = "GuardDuty RUNTIME_MONITORING feature must be enabled. Set auto_enable = 'ALL' to enable EC2 runtime monitoring. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/guardduty-controls.html#guardduty-13 for more details."
    }

    enforce {
        condition = local.ec2_agent_status == "ALL"
        error_message = "GuardDuty RUNTIME_MONITORING feature must have EC2_AGENT_MANAGEMENT enabled in additional_configuration. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/guardduty-controls.html#guardduty-13 for more details."
    }
}
