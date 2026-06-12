# ECS.16 - ECS task sets should not automatically assign public IP addresses

policy {}

input "ecs-taskset-assign-public-ip-disabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_ecs_task_set" "no_public_ip" {
    enforcement_level = input.ecs-taskset-assign-public-ip-disabled-enforcement-level
    locals {
        has_network_config = core::length(core::try(attrs.network_configuration, [])) > 0
        assign_public_ip = core::try(attrs.network_configuration[0].assign_public_ip, false)
    }

    enforce {
        condition = !local.has_network_config || local.assign_public_ip == false
        error_message = "ECS task set has assign_public_ip set to true. Public IP addresses should not be automatically assigned to prevent unintended internet access. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ecs-controls.html#ecs-16 for more details."
    }
}
