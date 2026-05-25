# Amazon EC2 instances launched using Auto Scaling group launch configurations should not have Public IP addresses

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resources not publicly accessible |

## Description

This control checks whether an Auto Scaling group's associated launch configuration assigns a public IP address to the group's instances. The control fails if the associated launch configuration assigns a public IP address.

Amazon EC2 instances in an Auto Scaling group launch configuration should not have an associated public IP address, except for in limited edge cases. Amazon EC2 instances should only be accessible from behind a load balancer instead of being directly exposed to the internet.

This rule is covered by the [autoscaling-launch-config-public-ip-disabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/autoscaling/autoscaling-launch-config-public-ip-disabled.policy.hcl) policy.

## Policy Results

```bash
trace:
	# autoscaling-launch-config-public-ip-disabled.policytest.hcl...
	running
	# resource.aws_launch_configuration.pass_public_ip_disabled...
	running
	# resource.aws_launch_configuration.pass_public_ip_disabled...
	pass
	# resource.aws_launch_configuration.fail_public_ip_enabled...
	running
	# resource.aws_launch_configuration.fail_public_ip_enabled...
	pass
	# resource.aws_launch_configuration.fail_public_ip_missing...
	running
	# resource.aws_launch_configuration.fail_public_ip_missing...
	pass
	# autoscaling-launch-config-public-ip-disabled.policytest.hcl...
	pass
```

---
