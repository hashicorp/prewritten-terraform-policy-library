# CloudFront distributions should have WAF enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Protective services |

## Description

This control checks whether CloudFront distributions are associated with either AWS WAF Classic or AWS WAF web ACLs. The control fails if the distribution is not associated with a web ACL.

AWS WAF is a web application firewall that helps protect web applications and APIs from attacks. It allows you to configure a set of rules, called a web access control list (web ACL), that allow, block, or count web requests based on customizable web security rules and conditions that you define. Ensure your CloudFront distribution is associated with an AWS WAF web ACL to help protect it from malicious attacks.

This rule is covered by the [cloudfront-associated-with-waf](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/cloudfront/cloudfront-associated-with-waf.policy.hcl) policy.

## Policy Results

```bash
trace:
	# cloudfront-associated-with-waf.policytest.hcl...
	running
	# resource.aws_cloudfront_distribution.pass_with_waf...
	running
	# resource.aws_cloudfront_distribution.pass_with_waf...
	pass
	# resource.aws_cloudfront_distribution.fail_without_waf...
	running
	# resource.aws_cloudfront_distribution.fail_without_waf...
	pass
	# cloudfront-associated-with-waf.policytest.hcl...
	pass
```

---