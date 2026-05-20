# S3 general purpose buckets should block public access

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Access control |

## Description

This control checks whether an Amazon S3 general purpose bucket blocks public access at the bucket level. The control fails if any of the following settings are set to false:

Block Public Access at the S3 bucket level provides controls to ensure that objects never have public access. Public access is granted to buckets and objects through access control lists (ACLs), bucket policies, or both.

Unless you intend to have your S3 buckets publicly accessible, you should configure the bucket level Amazon S3 Block Public Access feature.

This rule is covered by the [s3-bucket-level-public-access-prohibited](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/s3/s3-bucket-level-public-access-prohibited.policy.hcl) policy.

## Policy Results

```bash
trace:
      # s3-bucket-level-public-access-prohibited.policytest.hcl... running
      # resource.aws_s3_bucket_public_access_block.pass_all_settings_enabled... running
      # resource.aws_s3_bucket_public_access_block.pass_all_settings_enabled... pass
      # resource.aws_s3_bucket_public_access_block.fail_block_public_acls_false... running
      # resource.aws_s3_bucket_public_access_block.fail_block_public_acls_false... pass
      # resource.aws_s3_bucket_public_access_block.fail_block_public_policy_false... running
      # resource.aws_s3_bucket_public_access_block.fail_block_public_policy_false... pass
      # resource.aws_s3_bucket_public_access_block.fail_ignore_public_acls_false... running
      # resource.aws_s3_bucket_public_access_block.fail_ignore_public_acls_false... pass
      # resource.aws_s3_bucket_public_access_block.fail_restrict_public_buckets_false... running
      # resource.aws_s3_bucket_public_access_block.fail_restrict_public_buckets_false... pass
      # resource.aws_s3_bucket_public_access_block.fail_all_settings_false... running
      # resource.aws_s3_bucket_public_access_block.fail_all_settings_false... pass
      # resource.aws_s3_bucket_public_access_block.fail_missing_attributes... running
      # resource.aws_s3_bucket_public_access_block.fail_missing_attributes... pass
      # s3-bucket-level-public-access-prohibited.policytest.hcl... pass
```

---
