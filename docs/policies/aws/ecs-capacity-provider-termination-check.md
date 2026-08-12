# ECS capacity providers should have managed termination protection enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Data Protection |

## Description

This control checks whether an Amazon ECS capacity provider has managed termination protection enabled. The control fails if managed termination protection is not enabled on an ECS capacity provider.

Amazon ECS capacity providers manage the scaling of infrastructure for tasks in your clusters. When you use EC2 instances for your capacity, you use Auto Scaling group to manage the EC2 instances. Managed termination protection allows cluster auto scaling to control which instances are terminated. When you used managed termination protection, Amazon ECS only terminates EC2 instances that don't have any running Amazon ECS tasks.

When using managed termination protection, managed scaling must also be used otherwise managed termination protection doesn't work.

This rule is covered by the [ecs-capacity-provider-termination-check](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/ecs/ecs-capacity-provider-termination-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ecs-capacity-provider-termination-check.policytest.hcl...
      running
      # resource.aws_ecs_capacity_provider.pass_both_enabled...
      running
      # resource.aws_ecs_capacity_provider.pass_both_enabled...
      pass
      # resource.aws_ecs_capacity_provider.fail_termination_protection_disabled...
      running
      # resource.aws_ecs_capacity_provider.fail_termination_protection_disabled...
      pass
      # resource.aws_ecs_capacity_provider.fail_managed_scaling_disabled...
      running
      # resource.aws_ecs_capacity_provider.fail_managed_scaling_disabled...
      pass
      # resource.aws_ecs_capacity_provider.fail_both_disabled...
      running
      # resource.aws_ecs_capacity_provider.fail_both_disabled...
      pass
      # resource.aws_ecs_capacity_provider.fail_termination_protection_not_set...
      running
      # resource.aws_ecs_capacity_provider.fail_termination_protection_not_set...
      pass
      # resource.aws_ecs_capacity_provider.filtered_managed_instances_provider...
      running
      # resource.aws_ecs_capacity_provider.filtered_managed_instances_provider...
      pass
      # ecs-capacity-provider-termination-check.policytest.hcl...
      pass
```

---
