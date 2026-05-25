# Auto Scaling group launch configurations should configure EC2 instances to require Instance Metadata Service Version 2 (IMDSv2)

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure network configuration |

## Description

This control checks whether IMDSv2 is enabled on all instances launched by Amazon EC2 Auto Scaling groups. The control fails if the Instance Metadata Service (IMDS) version isn't included in the launch configuration or is configured as token optional, which is a setting that allows either IMDSv1 or IMDSv2.

IMDS provides data about your instance that you can use to configure or manage the running instance.

Version 2 of the IMDS adds new protections that weren't available in IMDSv1 to further safeguard your EC2 instances.

This rule is covered by the [autoscaling-launchconfig-requires-imdsv2](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/autoscaling/autoscaling-launchconfig-requires-imdsv2.policy.hcl) policy.

## Policy Results

```bash
trace:
	# autoscaling-launchconfig-requires-imdsv2.policytest.hcl...
	running
	# resource.aws_launch_configuration.pass_http_tokens_required...
	running
	# resource.aws_launch_configuration.pass_http_tokens_required...
	pass
	# resource.aws_launch_configuration.fail_http_tokens_optional...
	running
	# resource.aws_launch_configuration.fail_http_tokens_optional...
	pass
	# resource.aws_launch_configuration.fail_metadata_options_missing...
	running
	# resource.aws_launch_configuration.fail_metadata_options_missing...
	pass
	# autoscaling-launchconfig-requires-imdsv2.policytest.hcl...
	pass
```

---
