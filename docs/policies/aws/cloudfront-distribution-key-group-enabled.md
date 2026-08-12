# CloudFront distributions should use trusted key groups for signed URLs and cookies

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Access control |

## Description

This control checks whether an Amazon CloudFront distribution is configured to use trusted key groups for signed URL or signed cookie authentication. The control fails if the CloudFront distribution uses trusted signers, or if the distribution has no authentication configured.

To use signed URLs or signed cookies, you need a signer. A signer is either a trusted key group that you create in CloudFront, or an AWS account that contains a CloudFront key pair. We recommend that you use trusted key groups because with CloudFront key groups, you don't need to use the AWS account root user to manage the public keys for CloudFront signed URLs and signed cookies.

This rule is covered by the [cloudfront-distribution-key-group-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/cloudfront/cloudfront-distribution-key-group-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
	# cloudfront-distribution-key-group-enabled.policytest.hcl...
	running
	# resource.aws_cloudfront_distribution.pass_trusted_key_groups...
	running
	# resource.aws_cloudfront_distribution.pass_trusted_key_groups...
	pass
	# resource.aws_cloudfront_distribution.fail_missing_trusted_key_groups...
	running
	# resource.aws_cloudfront_distribution.fail_missing_trusted_key_groups...
	pass
	# cloudfront-distribution-key-group-enabled.policytest.hcl...
	pass
```

---