# CloudFront distributions should have a default root object configured

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resources not publicly accessible |

## Description

This control checks whether an Amazon CloudFront distribution with S3 origins is configured to return a specific object that is the default root object. The control fails if the CloudFront distribution uses S3 origins and doesn't have a default root object configured. This control doesn't apply to CloudFront distributions that use custom origins.

A user might sometimes request the distribution's root URL instead of an object in the distribution. When this happens, specifying a default root object can help you to avoid exposing the contents of your web distribution.

This rule is covered by the [cloudfront-default-root-object-configured](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/cloudfront/cloudfront-default-root-object-configured.policy.hcl) policy.

## Policy Results

```bash
trace:
      # cloudfront-default-root-object-configured.policytest.hcl... running
      # resource.aws_cloudfront_distribution.pass_s3_origin_with_default_root_object... running
      # resource.aws_cloudfront_distribution.pass_s3_origin_with_default_root_object... pass
      # resource.aws_cloudfront_distribution.fail_s3_origin_missing_default_root_object... running
      # resource.aws_cloudfront_distribution.fail_s3_origin_missing_default_root_object... pass
      # resource.aws_cloudfront_distribution.pass_custom_origin_no_default_root_object... running
      # resource.aws_cloudfront_distribution.pass_custom_origin_no_default_root_object... pass
      # resource.aws_cloudfront_distribution.pass_oac_s3_origin_with_default_root_object... running
      # resource.aws_cloudfront_distribution.pass_oac_s3_origin_with_default_root_object... pass
      # resource.aws_cloudfront_distribution.fail_oac_s3_origin_empty_default_root_object... running
      # resource.aws_cloudfront_distribution.fail_oac_s3_origin_empty_default_root_object... pass
      # cloudfront-default-root-object-configured.policytest.hcl... pass
```

---
