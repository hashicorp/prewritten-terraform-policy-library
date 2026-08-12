# ECS task definitions should not share the host's process namespace

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resource configuration |

## Description

This control checks if Amazon ECS task definitions are configured to share a host's process namespace with its containers. The control fails if the task definition shares the host's process namespace with the containers running on it. This control only evaluates the latest active revision of an Amazon ECS task definition.

A process ID (PID) namespace provides separation between processes. It prevents system processes from being visible, and allows PIDs to be reused, including PID 1. If the host's PID namespace is shared with containers, it would allow containers to see all of the processes on the host system. This reduces the benefit of process level isolation between the host and the containers. These circumstances could lead to unauthorized access to processes on the host itself, including the ability to manipulate and terminate them. Customers shouldn't share the host's process namespace with containers running on it.

This rule is covered by the [ecs-task-definition-pid-mode-check](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/ecs/ecs-task-definition-pid-mode-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ecs-task-definition-pid-mode-check.policytest.hcl... running
      # resource.aws_ecs_task_definition.pass_pid_mode_not_specified... running
      # resource.aws_ecs_task_definition.pass_pid_mode_not_specified... pass
      # resource.aws_ecs_task_definition.pass_pid_mode_task... running
      # resource.aws_ecs_task_definition.pass_pid_mode_task... pass
      # resource.aws_ecs_task_definition.fail_pid_mode_host... running
      # resource.aws_ecs_task_definition.fail_pid_mode_host... pass
      # ecs-task-definition-pid-mode-check.policytest.hcl... pass
```

---
