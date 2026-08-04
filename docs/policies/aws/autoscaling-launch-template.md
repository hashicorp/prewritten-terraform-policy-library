# Amazon EC2 Auto Scaling groups should use Amazon EC2 launch templates

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resource Configuration |

## Description

This control checks whether an Amazon EC2 Auto Scaling group is created from an EC2 launch template. This control fails if an Amazon EC2 Auto Scaling group is not created with a launch template or if a launch template is not specified in a mixed instances policy.

An EC2 Auto Scaling group can be created from either an EC2 launch template or a launch configuration. However, using a launch template to create an Auto Scaling group ensures that you have access to the latest features and improvements.

This rule is covered by the [autoscaling-launch-template](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/autoscaling/autoscaling-launch-template.policy.hcl) policy.

## Policy Results

```bash
trace:
	# autoscaling-launch-template.policytest.hcl...
	running
	# resource.aws_autoscaling_group.pass_with_launch_template...
	running
	# resource.aws_autoscaling_group.pass_with_launch_template...
	pass
	# resource.aws_autoscaling_group.fail_with_launch_configuration...
	running
	# resource.aws_autoscaling_group.fail_with_launch_configuration...
	pass
	# resource.aws_autoscaling_group.fail_missing_both...
	running
	# resource.aws_autoscaling_group.fail_missing_both...
	pass
	# autoscaling-launch-template.policytest.hcl...
	pass
```

---
