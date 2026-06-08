# Copyright IBM Corp. 2026

# ECS.4 - ECS containers should run as non-privileged containers

policy {}

resource_policy "aws_ecs_task_definition" "ecs_non_privileged_containers" {
    locals {
        container_def = core::jsondecode(attrs.container_definitions)
        privileged_containers = [
            for container in local.container_def : container
            if core::try(container.privileged, false) == true
        ]
    }

    enforce {
        condition = core::length(local.privileged_containers) == 0
        error_message = "ECS task definition contains one or more privileged containers. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ecs-controls.html#ecs-4 for more details."
    }
}
