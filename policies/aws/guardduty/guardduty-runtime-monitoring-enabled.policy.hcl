# Copyright IBM Corp. 2026

# GuardDuty.11 - GuardDuty Runtime Monitoring should be enabled.

policy {}

resource_policy "aws_guardduty_detector_feature" "runtime_monitoring_enabled" {
    filter = attrs.name == "RUNTIME_MONITORING"

    locals {
        additional_config = core::try(attrs.additional_configuration, [])
        addon_configs = [
            for config in local.additional_config : config
            if config.name == "EC2_AGENT_MANAGEMENT" || config.name == "ECS_FARGATE_AGENT_MANAGEMENT" || config.name == "EKS_ADDON_MANAGEMENT"
        ]
        addon_management_enabled = core::length(local.addon_configs) > 0 ? core::try(local.addon_configs[0].status, "DISABLED") == "ENABLED" : false
    }

    enforce {
        condition = core::try(attrs.status, "DISABLED") == "ENABLED"
        error_message = "GuardDuty Runtime Monitoring feature must have status 'ENABLED'. Enable Runtime Monitoring to detect threats in AWS workloads. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/guardduty-controls.html#guardduty-11 for more details."
    }

    enforce {
        condition = local.addon_management_enabled == true
        error_message = "GuardDuty Runtime Monitoring feature must enable at least one agent management configuration (EC2_AGENT_MANAGEMENT, ECS_FARGATE_AGENT_MANAGEMENT, or EKS_ADDON_MANAGEMENT) with status 'ENABLED'. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/guardduty-controls.html#guardduty-11 for more details."
    }
}

resource_policy "aws_guardduty_organization_configuration_feature" "runtime_monitoring_org_enabled" {
    filter = attrs.name == "RUNTIME_MONITORING"

    locals {
        additional_config = core::try(attrs.additional_configuration, [])
        addon_configs = [
            for config in local.additional_config : config
            if config.name == "EC2_AGENT_MANAGEMENT" || config.name == "ECS_FARGATE_AGENT_MANAGEMENT" || config.name == "EKS_ADDON_MANAGEMENT"
        ]
        addon_management_enabled = core::length(local.addon_configs) > 0 ? core::try(local.addon_configs[0].auto_enable, "NONE") == "ALL" : false
    }

    enforce {
        condition = core::try(attrs.auto_enable, "NONE") == "ALL"
        error_message = "GuardDuty organization configuration feature does not have RUNTIME_MONITORING properly configured for member accounts. Set auto_enable = 'ALL' to enable for all existing and new member accounts. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/guardduty-controls.html#guardduty-11 for more details."
    }

    enforce {
        condition = local.addon_management_enabled == true
        error_message = "GuardDuty organization configuration feature must have EC2_AGENT_MANAGEMENT, ECS_FARGATE_AGENT_MANAGEMENT, or EKS_ADDON_MANAGEMENT enabled for automated agent management for member accounts. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/guardduty-controls.html#guardduty-11 for more details."
    }
}
