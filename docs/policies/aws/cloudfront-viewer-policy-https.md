# CloudFront distributions should require encryption in transit

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks whether an Amazon CloudFront distribution requires viewers to use HTTPS directly or whether it uses redirection. The control fails if ViewerProtocolPolicy is set to allow-all for defaultCacheBehavior or for cacheBehaviors.

HTTPS (TLS) can be used to help prevent potential attackers from using person-in-the-middle or similar attacks to eavesdrop on or manipulate network traffic. Only encrypted connections over HTTPS (TLS) should be allowed. Encrypting data in transit can affect performance. You should test your application with this feature to understand the performance profile and the impact of TLS.

This rule is covered by the [cloudfront-viewer-policy-https](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/cloudfront/cloudfront-viewer-policy-https.policy.hcl) policy.

## Policy Results

```bash
trace:
      # cloudfront-viewer-policy-https.policytest.hcl... running
      # resource.aws_cloudfront_distribution.fail_default_cache_behavior_allow_all... running
      # resource.aws_cloudfront_distribution.fail_default_cache_behavior_allow_all... pass
      # resource.aws_cloudfront_distribution.pass_default_cache_behavior_redirect_to_https... running
      # resource.aws_cloudfront_distribution.pass_default_cache_behavior_redirect_to_https... pass
      # resource.aws_cloudfront_distribution.fail_ordered_cache_behavior_allow_all... running
      # resource.aws_cloudfront_distribution.fail_ordered_cache_behavior_allow_all... pass
      # resource.aws_cloudfront_distribution.pass_ordered_cache_behavior_https_only... running
      # resource.aws_cloudfront_distribution.pass_ordered_cache_behavior_https_only... pass
      # resource.aws_cloudfront_distribution.pass_missing_ordered_cache_behavior... running
      # resource.aws_cloudfront_distribution.pass_missing_ordered_cache_behavior... pass
      # cloudfront-viewer-policy-https.policytest.hcl... pass
```

---
