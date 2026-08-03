# Copyright IBM Corp. 2026

# ECS.4 - ECS containers should run as non-privileged containers

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "ecs-containers-nonprivileged-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_ecs_task_definition" "ecs_non_privileged_containers" {
    enforcement_level = input.ecs-containers-nonprivileged-enforcement-level
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
