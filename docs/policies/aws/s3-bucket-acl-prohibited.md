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
      # s3-bucket-acl-prohibited.policytest.hcl... running
      # resource.aws_s3_bucket.fail_canned_private... running
      # resource.aws_s3_bucket.fail_canned_private... pass
      # resource.aws_s3_bucket_acl.fail_canned_private_acl... running
      # resource.aws_s3_bucket_acl.fail_canned_private_acl... pass
      # resource.aws_s3_bucket.fail_canned_public_read... running
      # resource.aws_s3_bucket.fail_canned_public_read... pass
      # resource.aws_s3_bucket_acl.fail_canned_public_read_acl... running
      # resource.aws_s3_bucket_acl.fail_canned_public_read_acl... pass
      # resource.aws_s3_bucket.fail_acp_grants... running
      # resource.aws_s3_bucket.fail_acp_grants... pass
      # resource.aws_s3_bucket_acl.fail_acp_grants_acl... running
      # resource.aws_s3_bucket_acl.fail_acp_grants_acl... pass
      # resource.aws_s3_bucket.pass_no_acl_resource... running
      # resource.aws_s3_bucket.pass_no_acl_resource... pass
      # resource.aws_s3_bucket.pass_acl_resource_without_grants... running
      # resource.aws_s3_bucket.pass_acl_resource_without_grants... pass
      # resource.aws_s3_bucket_acl.pass_acl_resource_without_grants_acl... running
      # resource.aws_s3_bucket_acl.pass_acl_resource_without_grants_acl... pass
      # resource.aws_s3_bucket.fail_direct_canned_acl... running
      # resource.aws_s3_bucket.fail_direct_canned_acl... pass
      # s3-bucket-acl-prohibited.policytest.hcl... pass
```

---