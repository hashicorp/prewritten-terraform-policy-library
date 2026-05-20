# ECS task sets should not automatically assign public IP addresses

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resources not publicly accessible |

## Description

This control checks whether an Amazon ECS task set is configured to automatically assign public IP addresses. The control fails if AssignPublicIP is set to ENABLED.

A public IP address is reachable from the internet. If you configure your task set with a public IP address, the resources associated with the task set can be reached from the internet. ECS task sets shouldn't be publicly accessible, as this may allow unintended access to your container application servers.

This rule is covered by the [ecs-taskset-assign-public-ip-disabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/ecs/ecs-taskset-assign-public-ip-disabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ecs-taskset-assign-public-ip-disabled.policytest.hcl... running
      # resource.aws_ecs_task_set.compliant_explicit... running
      # resource.aws_ecs_task_set.compliant_explicit... pass
      # resource.aws_ecs_task_set.compliant_default... running
      # resource.aws_ecs_task_set.compliant_default... pass
      # resource.aws_ecs_task_set.non_compliant... running
      # resource.aws_ecs_task_set.non_compliant... pass
      # resource.aws_ecs_task_set.no_network_config... running
      # resource.aws_ecs_task_set.no_network_config... pass
      # ecs-taskset-assign-public-ip-disabled.policytest.hcl... pass
```

---
