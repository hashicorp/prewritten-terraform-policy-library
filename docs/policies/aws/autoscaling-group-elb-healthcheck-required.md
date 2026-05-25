# autoscaling-group-elb-healthcheck-required

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | AUTOSCALING |

## Description

Refer to [AWS Security Hub documentation](https://docs.aws.amazon.com/securityhub/latest/userguide/autoscaling-controls.html#autoscaling-1) for details.

This rule is covered by the [autoscaling-group-elb-healthcheck-required](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/autoscaling/autoscaling-group-elb-healthcheck-required.policy.hcl) policy.


## Policy Results

```bash
trace:
	# autoscaling-group-elb-healthcheck-required.policytest.hcl...
	running
	# resource.aws_autoscaling_group.pass_healthcheck_elb...
	running
	# resource.aws_autoscaling_group.pass_healthcheck_elb...
	pass
	# resource.aws_autoscaling_group.fail_healthcheck_ec2...
	running
	# resource.aws_autoscaling_group.fail_healthcheck_ec2...
	pass
	# resource.aws_autoscaling_group.fail_healthcheck_missing...
	running
	# resource.aws_autoscaling_group.fail_healthcheck_missing...
	pass
	# autoscaling-group-elb-healthcheck-required.policytest.hcl...
	pass
```

---
