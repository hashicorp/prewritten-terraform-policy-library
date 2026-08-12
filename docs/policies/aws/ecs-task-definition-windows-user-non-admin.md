# ECS Task Definitions should configure non-administrator users in Windows container definitions

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Root user access restrictions |

## Description

This control checks whether the latest active revision of an Amazon ECS task definition configures Windows containers to run as users that are not default administrators. The control fails if a default administrator is configured as user or user configuration is absent for any container.

When Windows containers run with administrator privileges, they pose several significant security risks. Administrators have unrestricted access within the container. This elevated access increases the risk of container escape attacks, where an attacker could potentially break out of container isolation and access the underlying host system.

This control only evaluates the container definitions in a task definition if the operatingSystemFamily is configured as WINDOWS_SERVER or operatingSystemFamily is not configured in the task definition. The control will generate a FAILED finding for an evaluated task definition if any container definition in the task definition has user not configured or user configured as default administrator for WINDOWS_SERVER containers which is "containeradministrator".

This rule is covered by the [ecs-task-definition-windows-user-non-admin](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/ecs/ecs-task-definition-windows-user-non-admin.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ecs-task-definition-windows-user-non-admin.policytest.hcl...
      running
      # resource.aws_ecs_task_definition.pass_windows_2022_core_with_custom_user...
      running
      # resource.aws_ecs_task_definition.pass_windows_2022_core_with_custom_user...
      pass
      # resource.aws_ecs_task_definition.fail_windows_2019_full_missing_user...
      running
      # resource.aws_ecs_task_definition.fail_windows_2019_full_missing_user...
      pass
      # resource.aws_ecs_task_definition.fail_windows_2022_full_with_admin_user...
      running
      # resource.aws_ecs_task_definition.fail_windows_2022_full_with_admin_user...
      pass
      # resource.aws_ecs_task_definition.fail_windows_2019_core_multiple_one_missing_user...
      running
      # resource.aws_ecs_task_definition.fail_windows_2019_core_multiple_one_missing_user...
      pass
      # resource.aws_ecs_task_definition.fail_windows_2022_core_multiple_one_admin...
      running
      # resource.aws_ecs_task_definition.fail_windows_2022_core_multiple_one_admin...
      pass
      # resource.aws_ecs_task_definition.fail_no_runtime_platform_missing_user...
      running
      # resource.aws_ecs_task_definition.fail_no_runtime_platform_missing_user...
      pass
      # resource.aws_ecs_task_definition.pass_windows_2016_full_all_custom_users...
      running
      # resource.aws_ecs_task_definition.pass_windows_2016_full_all_custom_users...
      pass
      # ecs-task-definition-windows-user-non-admin.policytest.hcl...
      pass
```

---
