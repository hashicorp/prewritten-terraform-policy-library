# Auto Scaling groups should use multiple instance types in multiple Availability Zones

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | High availability |

## Description

This control checks whether an Amazon EC2 Auto Scaling group uses multiple instance types. The control fails if the Auto Scaling group has only one instance type defined.

You can enhance availability by deploying your application across multiple instance types running in multiple Availability Zones. Security Hub CSPM recommends using multiple instance types so that the Auto Scaling group can launch another instance type if there is insufficient instance capacity in your chosen Availability Zones.

This rule is covered by the [autoscaling-multiple-instance-types](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/autoscaling/autoscaling-multiple-instance-types.policy.hcl) policy.


## Policy Results

```bash
trace:
	# autoscaling-multiple-instance-types.policytest.hcl...
	running
	# resource.aws_autoscaling_group.pass_mixed_instances_policy...
	running
	# resource.aws_autoscaling_group.pass_mixed_instances_policy...
	pass
	# resource.aws_autoscaling_group.fail_launch_template_only...
	running
	# resource.aws_autoscaling_group.fail_launch_template_only...
	pass
	# resource.aws_autoscaling_group.fail_launch_configuration...
	running
	# resource.aws_autoscaling_group.fail_launch_configuration...
	pass
	# autoscaling-multiple-instance-types.policytest.hcl...
	pass
```

---
