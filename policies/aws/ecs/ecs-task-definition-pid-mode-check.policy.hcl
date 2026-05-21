# ECS.3 - ECS task definitions should not share the host's process namespace.

policy {}

resource_policy "aws_ecs_task_definition" "pid_mode_check" {
    enforce {
        condition = core::try(attrs.pid_mode, "task") != "host"
        error_message = "ECS task definition has pid_mode set to 'host', which shares the host's process namespace with containers. This reduces process isolation and security. Remove the pid_mode attribute or set it to 'task' for proper isolation. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ecs-controls.html#ecs-3 for more details."
    }
}
