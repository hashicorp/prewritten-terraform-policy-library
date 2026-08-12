# S3 general purpose buckets should block public write access

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure network configuration |

## Description

This control checks whether an Amazon S3 general purpose bucket permits public write access. It evaluates the block public access settings, the bucket policy, and the bucket access control list (ACL). The control fails if the bucket permits public write access.

If an S3 bucket has a bucket policy, this control doesn't evaluate policy conditions that use wildcard characters or variables. To produce a PASSED finding, conditions in the bucket policy must only use fixed values, which are values that don't contain wildcard characters or policy variables. For information about policy variables, see Variables and tags in the AWS Identity and Access Management User Guide.

Some use cases require that everyone on the internet be able to write to your S3 bucket. However, those situations are rare. To ensure the integrity and security of your data, your S3 bucket should not be publicly writable.

This rule is covered by the [s3-bucket-public-write-prohibited](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/s3/s3-bucket-public-write-prohibited.policy.hcl) policy.

## Policy Results

```bash
trace:
      # s3-bucket-public-write-prohibited.policytest.hcl... running
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
      # resource.aws_s3_bucket_acl.pass_private_acl... running
      # resource.aws_s3_bucket_acl.pass_private_acl... pass
      # resource.aws_s3_bucket_acl.fail_public_read_write_acl... running
      # resource.aws_s3_bucket_acl.fail_public_read_write_acl... pass
      # resource.aws_s3_bucket_acl.fail_acp_write_all_users... running
      # resource.aws_s3_bucket_acl.fail_acp_write_all_users... pass
      # resource.aws_s3_bucket_acl.fail_acp_full_control_authenticated... running
      # resource.aws_s3_bucket_acl.fail_acp_full_control_authenticated... pass
      # s3-bucket-public-write-prohibited.policytest.hcl... pass
```

---
