# ECS task definitions should configure containers to be limited to read-only access to root filesystems

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure access management |

## Description

This control checks whether ECS task definitions configure containers to be limited to read-only access to mounted root file systems. The control fails if the readonlyRootFilesystem parameter in the container definitions of ECS task definition is set to false, or the parameter doesn't exist in the container definition within the task definition. This control evaluates only the latest active revision of an Amazon ECS task definition.

If the readonlyRootFilesystem parameter is set to true in an Amazon ECS task definition, the ECS container is given read-only access to its root file system. This reduces security attack vectors because the container instance's root file system can't be tampered with or written to without explicit volume mounts that have read-write permissions for file system folders and directories. Enabling this option also adheres to the principle of least privilege.

The readonlyRootFilesystem parameter is not supported for Windows containers. Task definitions with runtimePlatform configured to specify a WINDOWS_SERVER OS family are marked as NOT_APPLICABLE and will not generate findings for this control.

This rule is covered by the [ecs-containers-readonly-access](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/ecs/ecs-containers-readonly-access.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ecs-containers-readonly-access.policytest.hcl... running
      # resource.aws_ecs_task_definition.pass_single_container_readonly_true... running
      # resource.aws_ecs_task_definition.pass_single_container_readonly_true... pass
      # resource.aws_ecs_task_definition.pass_multiple_containers_all_readonly_true... running
      # resource.aws_ecs_task_definition.pass_multiple_containers_all_readonly_true... pass
      # resource.aws_ecs_task_definition.fail_single_container_readonly_false... running
      # resource.aws_ecs_task_definition.fail_single_container_readonly_false... pass
      # resource.aws_ecs_task_definition.fail_single_container_missing_readonly... running
      # resource.aws_ecs_task_definition.fail_single_container_missing_readonly... pass
      # resource.aws_ecs_task_definition.fail_multiple_containers_partial_readonly... running
      # resource.aws_ecs_task_definition.fail_multiple_containers_partial_readonly... pass
      # resource.aws_ecs_task_definition.fail_multiple_containers_none_readonly... running
      # resource.aws_ecs_task_definition.fail_multiple_containers_none_readonly... pass
      # ecs-containers-readonly-access.policytest.hcl... pass
```

---
