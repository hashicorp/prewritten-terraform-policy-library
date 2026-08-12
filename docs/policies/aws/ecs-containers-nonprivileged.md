# ECS containers should run as non-privileged

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Root user access restrictions |

## Description

This control checks if the privileged parameter in the container definition of Amazon ECS Task Definitions is set to true. The control fails if this parameter is equal to true. This control only evaluates the latest active revision of an Amazon ECS task definition.

We recommend that you remove elevated privileges from your ECS task definitions. When the privilege parameter is true, the container is given elevated privileges on the host container instance (similar to the root user).

This rule is covered by the [ecs-containers-nonprivileged](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/ecs/ecs-containers-nonprivileged.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ecs-containers-nonprivileged.policytest.hcl... running
      # resource.aws_ecs_task_definition.passes_when_privileged_omitted... running
      # resource.aws_ecs_task_definition.passes_when_privileged_omitted... pass
      # resource.aws_ecs_task_definition.passes_when_privileged_false... running
      # resource.aws_ecs_task_definition.passes_when_privileged_false... pass
      # resource.aws_ecs_task_definition.fails_when_privileged_true... running
      # resource.aws_ecs_task_definition.fails_when_privileged_true... pass
      # resource.aws_ecs_task_definition.fails_when_any_container_privileged... running
      # resource.aws_ecs_task_definition.fails_when_any_container_privileged... pass
      # ecs-containers-nonprivileged.policytest.hcl... pass
```

---
