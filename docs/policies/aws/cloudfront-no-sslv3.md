# Policy: CloudFront.10 - CloudFront distributions should not use SSLv3 between edge locations and custom origins

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Security |

## Description

CloudFront distribution uses deprecated SSLv3 protocol for custom origins: ${core::join(", ", local.affected_origins)}. SSLv3 is insufficiently secure and should not be used. Use TLSv1.2 or later for HTTPS communication to custom origins. Update the origin_ssl_protocols configuration to remove 'SSLv3'. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/cloudfront-controls.html#cloudfront-10 for more details.

This rule is covered by the [cloudfront-no-sslv3](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/cloudfront/cloudfront-no-sslv3.policy.hcl) policy.

## Policy Results

```bash
trace:
      # cloudfront-no-sslv3.policytest.hcl... 
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
      # cloudfront-no-sslv3.policytest.hcl... 
      pass
```

---
