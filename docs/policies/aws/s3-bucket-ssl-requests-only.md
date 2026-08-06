# S3 general purpose buckets should require requests to use SSL

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure access management |

## Description

This control checks whether an Amazon S3 general purpose bucket has a policy that requires requests to use SSL. The control fails if the bucket policy doesn't require requests to use SSL.

S3 buckets should have policies that require all requests (`Action: s3:*`) to only accept transmission of data over HTTPS in the S3 resource policy, indicated by the condition key `aws:SecureTransport`.

This rule is covered by the [s3-bucket-ssl-requests-only](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/s3/s3-bucket-ssl-requests-only.policy.hcl) policy.

## Policy Results

```bash
trace:
      # s3-bucket-ssl-requests-only.policytest.hcl...
      running
      # resource.aws_s3_bucket.compliant...
      running
      # resource.aws_s3_bucket.compliant...
      pass
      # resource.aws_s3_bucket_policy.compliant...
      running
      # resource.aws_s3_bucket_policy.compliant...
      pass
      # resource.aws_s3_bucket.no_policy...
      running
      # resource.aws_s3_bucket.no_policy...
      pass
      # resource.aws_s3_bucket.wrong_policy...
      running
      # resource.aws_s3_bucket.wrong_policy...
      pass
      # resource.aws_s3_bucket_policy.wrong_policy...
      running
      # resource.aws_s3_bucket_policy.wrong_policy...
      pass
      # s3-bucket-ssl-requests-only.policytest.hcl...
      pass
```

---