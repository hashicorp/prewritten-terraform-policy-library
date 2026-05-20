# ECS.12 - ECS clusters should use Container Insights.

policy {}

resource_policy "aws_ecs_cluster" "container_insights_enabled" {
    locals {
        cluster_settings = core::try(attrs.setting, [])
        container_insights_settings = [
            for setting in local.cluster_settings : setting
            if core::try(setting.name, "") == "containerInsights"
        ]
        allowed_values = ["enabled", "enhanced"]
        container_insights_disabled = [
            for setting in local.container_insights_settings : setting
            if !core::contains(local.allowed_values, core::try(setting.value, ""))
        ]
    }

    enforce {
        condition = core::length(local.container_insights_settings) > 0
        error_message = "ECS cluster must define a setting block with name 'containerInsights'. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ecs-controls.html#ecs-12 for more details."
    }

    enforce {
        condition = core::length(local.container_insights_disabled) == 0
        error_message = "ECS cluster setting 'containerInsights' must be set to 'enabled' or 'enhanced'. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ecs-controls.html#ecs-12 for more details."
    }
}
