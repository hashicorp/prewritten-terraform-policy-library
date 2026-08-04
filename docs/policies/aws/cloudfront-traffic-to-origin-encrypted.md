# CloudFront distributions should encrypt traffic to custom origins

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks if Amazon CloudFront distributions are encrypting traffic to custom origins. This control fails for a CloudFront distribution whose origin protocol policy allows 'http-only'. This control also fails if the distribution's origin protocol policy is 'match-viewer' while the viewer protocol policy is 'allow-all'.

HTTPS (TLS) can be used to help prevent eavesdropping or manipulation of network traffic. Only encrypted connections over HTTPS (TLS) should be allowed.

This rule is covered by the [cloudfront-traffic-to-origin-encrypted](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/cloudfront/cloudfront-traffic-to-origin-encrypted.policy.hcl) policy.

## Policy Results

```bash
trace:
      # cloudfront-traffic-to-origin-encrypted.policytest.hcl...
      running
      # resource.aws_cloudfront_distribution.https_only_custom_origin_passes...
      running
      # resource.aws_cloudfront_distribution.https_only_custom_origin_passes...
      pass
      # resource.aws_cloudfront_distribution.match_viewer_redirect_to_https_passes...
      running
      # resource.aws_cloudfront_distribution.match_viewer_redirect_to_https_passes...
      pass
      # resource.aws_cloudfront_distribution.http_only_custom_origin_fails...
      running
      # resource.aws_cloudfront_distribution.http_only_custom_origin_fails...
      pass
      # resource.aws_cloudfront_distribution.match_viewer_allow_all_fails...
      running
      # resource.aws_cloudfront_distribution.match_viewer_allow_all_fails...
      pass
      # cloudfront-traffic-to-origin-encrypted.policytest.hcl...
      pass
```

---
