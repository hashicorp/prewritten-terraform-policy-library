# Auto Scaling groups with multiple instance types should have Capacity Rebalancing enabled

| Provider | Category |
| ------------------- | -------- |
| Amazon Web Services | Resilience |

## Description

This policy checks if Capacity Rebalancing is enabled for Amazon EC2 Auto Scaling groups that use multiple instance types. The policy fails if capacity Rebalancing is not enabled.

The policy evaluates `aws_autoscaling_group` resources.

This rule is covered by the [ec2-autoscaling-capacity-rebalancing-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/autoscaling/ec2-autoscaling-capacity-rebalancing-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      #
      ec2-autoscaling-capacity-rebalancing-enabled.policytest.hcl...
      running
      #
      resource.aws_autoscaling_group.pass_no_mixed_instances_policy...
      running
      #
      resource.aws_autoscaling_group.pass_no_mixed_instances_policy...
      pass
      #
      resource.aws_autoscaling_group.pass_single_override_no_requirements...
      running
      #
      resource.aws_autoscaling_group.pass_single_override_no_requirements...
      pass
      #
      resource.aws_autoscaling_group.pass_multiple_overrides_rebalance_enabled...
      running
      #
      resource.aws_autoscaling_group.pass_multiple_overrides_rebalance_enabled...
      pass
      #
      resource.aws_autoscaling_group.fail_multiple_overrides_rebalance_disabled...
      running
      #
      resource.aws_autoscaling_group.fail_multiple_overrides_rebalance_disabled...
      pass
      #
      resource.aws_autoscaling_group.pass_instance_requirements_rebalance_enabled...
      running
      #
      resource.aws_autoscaling_group.pass_instance_requirements_rebalance_enabled...
      pass
      #
      resource.aws_autoscaling_group.fail_instance_requirements_rebalance_disabled...
      running
      #
      resource.aws_autoscaling_group.fail_instance_requirements_rebalance_disabled...
      pass
      #
      resource.aws_autoscaling_group.fail_multiple_overrides_rebalance_omitted...
      running
      #
      resource.aws_autoscaling_group.fail_multiple_overrides_rebalance_omitted...
      pass
      #
      ec2-autoscaling-capacity-rebalancing-enabled.policytest.hcl...
      pass
```

---
