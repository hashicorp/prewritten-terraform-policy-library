# CloudFront distributions should not use deprecated SSL protocols between edge locations and custom origins

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | CLOUDFRONT |

## Description

This control checks if Amazon CloudFront distributions are using deprecated SSL protocols for HTTPS communication between CloudFront edge locations and your custom origins. This control fails if a CloudFront distribution has a CustomOriginConfig where OriginSslProtocols includes SSLv3.

In 2015, the Internet Engineering Task Force (IETF) officially announced that SSL 3.0 should be deprecated due to the protocol being insufficiently secure. It is recommended that you use TLSv1.2 or later for HTTPS communication to your custom origins.

This rule is covered by the [cloudfront-no-deprecated-ssl-protocols](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/cloudfront/cloudfront-no-deprecated-ssl-protocols.policy.hcl) policy.

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
