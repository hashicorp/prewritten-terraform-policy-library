# S3 general purpose buckets should block public read access

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure network configuration |

## Description

This control checks whether an Amazon S3 general purpose bucket permits public read access. It evaluates the block public access settings, the bucket policy, and the bucket access control list (ACL). The control fails if the bucket permits public read access.

If an S3 bucket has a bucket policy, this control doesn't evaluate policy conditions that use wildcard characters or variables. To produce a PASSED finding, conditions in the bucket policy must only use fixed values, which are values that don't contain wildcard characters or policy variables. For information about policy variables, see Variables and tags in the AWS Identity and Access Management User Guide.

Some use cases may require that everyone on the internet be able to read from your S3 bucket. However, those situations are rare. To ensure the integrity and security of your data, your S3 bucket should not be publicly readable.

This rule is covered by the [s3-bucket-public-read-prohibited](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/s3/s3-bucket-public-read-prohibited.policy.hcl) policy.

## Policy Results

```bash
trace:
      # s3-bucket-public-read-prohibited.policytest.hcl... running
      # resource.aws_s3_bucket_public_access_block.pass_all_settings_enabled... running
      # resource.aws_s3_bucket_public_access_block.pass_all_settings_enabled... pass
      # resource.aws_s3_bucket_public_access_block.fail_only_block_public_acls... running
      # resource.aws_s3_bucket_public_access_block.fail_only_block_public_acls... pass
      # resource.aws_s3_bucket_public_access_block.fail_only_block_public_policy... running
      # resource.aws_s3_bucket_public_access_block.fail_only_block_public_policy... pass
      # resource.aws_s3_bucket_public_access_block.fail_three_settings_enabled... running
      # resource.aws_s3_bucket_public_access_block.fail_three_settings_enabled... pass
      # resource.aws_s3_bucket_public_access_block.fail_two_settings_enabled... running
      # resource.aws_s3_bucket_public_access_block.fail_two_settings_enabled... pass
      # resource.aws_s3_bucket_public_access_block.fail_all_settings_disabled... running
      # resource.aws_s3_bucket_public_access_block.fail_all_settings_disabled... pass
      # resource.aws_s3_bucket_public_access_block.fail_no_settings_specified... running
      # resource.aws_s3_bucket_public_access_block.fail_no_settings_specified... pass
      # resource.aws_s3_bucket_acl.pass_acl_private... running
      # resource.aws_s3_bucket_acl.pass_acl_private... pass
      # resource.aws_s3_bucket_acl.pass_acl_bucket_owner_full_control... running
      # resource.aws_s3_bucket_acl.pass_acl_bucket_owner_full_control... pass
      # resource.aws_s3_bucket_acl.fail_acl_public_read... running
      # resource.aws_s3_bucket_acl.fail_acl_public_read... pass
      # resource.aws_s3_bucket_acl.fail_acl_public_read_write... running
      # resource.aws_s3_bucket_acl.fail_acl_public_read_write... pass
      # resource.aws_s3_bucket_acl.fail_access_control_policy_all_users... running
      # resource.aws_s3_bucket_acl.fail_access_control_policy_all_users... pass
      # resource.aws_s3_bucket_acl.pass_access_control_policy_specific_account... running
      # resource.aws_s3_bucket_acl.pass_access_control_policy_specific_account... pass
      # s3-bucket-public-read-prohibited.policytest.hcl... pass
```

---
