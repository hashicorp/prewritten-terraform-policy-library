# CloudFront distributions should have logging enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether server access logging is enabled on CloudFront distributions. The control fails if access logging is not enabled for a distribution. This control only evaluates whether standard logging (legacy) is enabled for a distribution.

CloudFront access logs provide detailed information about every user request that CloudFront receives. Each log contains information such as the date and time the request was received, the IP address of the viewer that made the request, the source of the request, and the port number of the request from the viewer. These logs are useful for applications such as security and access audits and forensics investigation. For more information about analyzing access logs, see Query Amazon CloudFront logs in the Amazon Athena User Guide.

This rule is covered by the [cloudfront-accesslogs-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/cloudfront/cloudfront-accesslogs-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
	# cloudfront-accesslogs-enabled.policytest.hcl...
	running
	# resource.aws_cloudfront_distribution.pass_logging_enabled...
	running
	# resource.aws_cloudfront_distribution.pass_logging_enabled...
	pass
	# resource.aws_cloudfront_distribution.fail_logging_disabled...
	running
	# resource.aws_cloudfront_distribution.fail_logging_disabled...
	pass
	# resource.aws_cloudfront_distribution.fail_logging_config_missing...
	running
	# resource.aws_cloudfront_distribution.fail_logging_config_missing...
	pass
	# cloudfront-accesslogs-enabled.policytest.hcl...
	pass
```

---