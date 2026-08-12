# ACLs should not be used to manage user access to S3 general purpose buckets

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Access control |

## Description
This control checks whether an Amazon S3 general purpose bucket provides user permissions with an access control list (ACL). The control fails if an ACL is configured for managing user access on the bucket.

ACLs are legacy access control mechanisms that predate IAM. Instead of ACLs, we recommend using S3 bucket policies or AWS Identity and Access Management (IAM) policies to manage access to your S3 buckets.

This rule is covered by the [s3-bucket-acl-prohibited](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/s3/s3-bucket-acl-prohibited.policy.hcl) policy.

## Policy Results

```bash
trace:
      # s3-bucket-acl-prohibited.policytest.hcl...
      running
      # resource.aws_s3_bucket.bucket_pass...
      running
      # resource.aws_s3_bucket.bucket_pass...
      pass
      # resource.aws_s3_bucket_ownership_controls.ownership_controls_pass...
      running
      # resource.aws_s3_bucket_ownership_controls.ownership_controls_pass...
      pass
      # resource.aws_s3_bucket.bucket_acl_fail...
      running
      # resource.aws_s3_bucket.bucket_acl_fail...
      pass
      # resource.aws_s3_bucket_acl.bucket_acl_fail...
      running
      # resource.aws_s3_bucket_acl.bucket_acl_fail...
      pass
      # resource.aws_s3_bucket_ownership_controls.ownership_controls_fail...
      running
      # resource.aws_s3_bucket_ownership_controls.ownership_controls_fail...
      pass
      # s3-bucket-acl-prohibited.policytest.hcl...
      pass
```

---