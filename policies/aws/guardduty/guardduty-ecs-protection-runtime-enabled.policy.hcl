# Copyright IBM Corp. 2026

# GuardDuty ECS Runtime Monitoring should be enabled

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.65.0, < 7.0.0"
    }
  }
}

input "guardduty-ecs-protection-runtime-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

locals {
  ecs_guardduty_detector_features = core::getresources("aws_guardduty_detector_feature", {})
}

resource_policy "aws_guardduty_detector" "ecs_runtime_monitoring" {
    enforcement_level = input.guardduty-ecs-protection-runtime-enabled-enforcement-level

    locals {
        detector_id = core::try(attrs.id, "")
        matching_features = [
            for feature in local.ecs_guardduty_detector_features : feature
            if core::try(feature.detector_id, "") == local.detector_id
              && core::try(feature.name, "") == "RUNTIME_MONITORING"
              && core::try(feature.status, "DISABLED") == "ENABLED"
              && core::length([
                  for config in core::try(feature.additional_configuration, []) : config
                  if core::try(config.name, "") == "ECS_FARGATE_AGENT_MANAGEMENT"
                    && core::try(config.status, "DISABLED") == "ENABLED"
              ]) > 0
        ]
    }

    enforce {
        condition = core::length(local.matching_features) > 0
        error_message = "GuardDuty detector must have enabled runtime monitoring with ECS Fargate agent management."
    }
}

resource_policy "aws_guardduty_detector_feature" "ecs_runtime_monitoring" {
    enforcement_level = input.guardduty-ecs-protection-runtime-enabled-enforcement-level
    filter = attrs.name == "RUNTIME_MONITORING"

    locals {
        feature_enabled = core::try(attrs.status, "DISABLED") == "ENABLED"

        additional_configs = core::try(attrs.additional_configuration, [])
        ecs_fargate_configs = [
            for config in local.additional_configs :
            config if core::try(config.name, "") == "ECS_FARGATE_AGENT_MANAGEMENT"
        ]
        ecs_fargate_enabled = core::length(local.ecs_fargate_configs) > 0 ? core::try(local.ecs_fargate_configs[0].status, "DISABLED") == "ENABLED" : false
    }

    enforce {
        condition = local.feature_enabled
        error_message = "GuardDuty detector feature must have RUNTIME_MONITORING status set to 'ENABLED'"
    }

    enforce {
        condition = local.ecs_fargate_enabled
        error_message = "GuardDuty detector feature must have ECS_FARGATE_AGENT_MANAGEMENT enabled in additional_configuration"
    }
}

resource_policy "aws_guardduty_organization_configuration_feature" "ecs_runtime_monitoring" {
    enforcement_level = input.guardduty-ecs-protection-runtime-enabled-enforcement-level
    filter = attrs.name == "RUNTIME_MONITORING"

    locals {
        feature_enabled = core::try(attrs.auto_enable, "NONE") == "ALL"

        additional_configs = core::try(attrs.additional_configuration, [])
        ecs_fargate_configs = [
            for config in local.additional_configs :
            config if core::try(config.name, "") == "ECS_FARGATE_AGENT_MANAGEMENT"
        ]
        ecs_fargate_enabled = core::length(local.ecs_fargate_configs) > 0 ? core::try(local.ecs_fargate_configs[0].auto_enable, "NONE") == "ALL" : false
    }

    enforce {
        condition = local.feature_enabled
        error_message = "GuardDuty detector feature must have RUNTIME_MONITORING status set to 'ALL'"
    }

    enforce {
        condition = local.ecs_fargate_enabled
        error_message = "GuardDuty detector feature must have ECS_FARGATE_AGENT_MANAGEMENT enabled in additional_configuration"
    }
}
