# CloudFront distributions should use custom SSL/TLS certificates

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks whether CloudFront distributions are using the default SSL/TLS certificate CloudFront provides. This control passes if the CloudFront distribution uses a custom SSL/TLS certificate. This control fails if the CloudFront distribution uses the default SSL/TLS certificate.

Custom SSL/TLS allow your users to access content by using alternate domain names. You can store custom certificates in AWS Certificate Manager (recommended), or in IAM.

This rule is covered by the [cloudfront-custom-ssl-certificate](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/cloudfront/cloudfront-custom-ssl-certificate.policy.hcl) policy.

## Policy Results

```bash
trace:
	# cloudfront-custom-ssl-certificate.policytest.hcl...
	running
	# resource.aws_cloudfront_distribution.pass_custom_ssl...
	running
	# resource.aws_cloudfront_distribution.pass_custom_ssl...
	pass
	# resource.aws_cloudfront_distribution.fail_default_certificate...
	running
	# resource.aws_cloudfront_distribution.fail_default_certificate...
	pass
	# cloudfront-custom-ssl-certificate.policytest.hcl...
	pass
```

---