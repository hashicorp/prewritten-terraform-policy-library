# CloudFront distributions should encrypt traffic to custom origins

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks if Amazon CloudFront distributions are encrypting traffic to custom origins. This control fails for a CloudFront distribution whose origin protocol policy allows 'http-only'. This control also fails if the distribution's origin protocol policy is 'match-viewer' while the viewer protocol policy is 'allow-all'.

HTTPS (TLS) can be used to help prevent eavesdropping or manipulation of network traffic. Only encrypted connections over HTTPS (TLS) should be allowed.

This rule is covered by the [cloudfront-no-deprecated-ssl-protocols](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/cloudfront/cloudfront-no-deprecated-ssl-protocols.policy.hcl) policy.

## Policy Results

```bash
trace:
      # cloudfront-no-deprecated-ssl-protocols.policytest.hcl...
      running
      # resource.aws_cloudfront_distribution.pass_custom_origin_tlsv12_only...
      running
      # resource.aws_cloudfront_distribution.pass_custom_origin_tlsv12_only...
      pass
      # resource.aws_cloudfront_distribution.fail_custom_origin_with_sslv3...
      running
      # resource.aws_cloudfront_distribution.fail_custom_origin_with_sslv3...
      pass
      # resource.aws_cloudfront_distribution.pass_s3_origin_only...
      running
      # resource.aws_cloudfront_distribution.pass_s3_origin_only...
      pass
      # resource.aws_cloudfront_distribution.fail_multiple_origins_one_with_sslv3...
      running
      # resource.aws_cloudfront_distribution.fail_multiple_origins_one_with_sslv3...
      pass
      # resource.aws_cloudfront_distribution.pass_custom_origin_multiple_tls_no_sslv3...
      running
      # resource.aws_cloudfront_distribution.pass_custom_origin_multiple_tls_no_sslv3...
      pass
      # resource.aws_cloudfront_distribution.pass_mixed_s3_and_custom_compliant...
      running
      # resource.aws_cloudfront_distribution.pass_mixed_s3_and_custom_compliant...
      pass
      # cloudfront-no-deprecated-ssl-protocols.policytest.hcl...
      pass
```

---
