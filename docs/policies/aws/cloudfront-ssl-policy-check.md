# CloudFront distributions should use the recommended TLS security policy

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks whether an Amazon CloudFront distribution is configured to use a recommended TLS security policy. The control fails if the CloudFront distribution is not configured to use a recommended TLS security policy.

If you configure an Amazon CloudFront distribution to require viewers to use HTTPS to access content, you have to choose a security policy and specify the minimum SSL/TLS protocol version to use. This determines which protocol version CloudFront uses to communicate with viewers, and the ciphers that CloudFront uses to encrypt the communications. We recommend using the latest security policy that CloudFront provides. This ensures that CloudFront uses the latest cipher suites to encrypt data in transit between a viewer and a CloudFront distribution.

This control generates findings only for CloudFront distributions that are configured to use custom SSL certificates and are not configured to support legacy clients.

This rule is covered by the [cloudfront-ssl-policy-check](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/cloudfront/cloudfront-ssl-policy-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # cloudfront-ssl-policy-check.policytest.hcl...
      running
      # resource.aws_cloudfront_distribution.custom_acm_recommended_tls_2021...
      running
      # resource.aws_cloudfront_distribution.custom_acm_recommended_tls_2021...
      pass
      # resource.aws_cloudfront_distribution.custom_iam_recommended_tls_2025...
      running
      # resource.aws_cloudfront_distribution.custom_iam_recommended_tls_2025...
      pass
      # resource.aws_cloudfront_distribution.custom_acm_legacy_tls...
      running
      # resource.aws_cloudfront_distribution.custom_acm_legacy_tls...
      pass
      # resource.aws_cloudfront_distribution.default_certificate_out_of_scope...
      running
      # resource.aws_cloudfront_distribution.default_certificate_out_of_scope...
      pass
      # cloudfront-ssl-policy-check.policytest.hcl...
      pass
```

---
