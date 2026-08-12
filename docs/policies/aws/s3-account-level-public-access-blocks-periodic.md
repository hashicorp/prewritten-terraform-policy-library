# S3 general purpose buckets should have block public access settings enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure network configuration |

## Description

This control checks whether the preceding Amazon S3 block public access settings are configured at the account level for an S3 general purpose bucket. The control fails if one or more of the block public access settings are set to false.

The control fails if any of the settings are set to false, or if any of the settings are not configured.

Amazon S3 public access block is designed to provide controls across an entire AWS account or at the individual S3 bucket level to ensure that objects never have public access. Public access is granted to buckets and objects through access control lists (ACLs), bucket policies, or both.

Unless you intend to have your S3 buckets be publicly accessible, you should configure the account level Amazon S3 Block Public Access feature.

To learn more, see Using Amazon S3 Block Public Access in the Amazon Simple Storage Service User Guide.

This rule is covered by the [s3-account-level-public-access-blocks-periodic](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/s3/s3-account-level-public-access-blocks-periodic.policy.hcl) policy.

## Policy Results

```bash
trace:
      # s3-account-level-public-access-blocks-periodic.policytest.hcl... running
      # resource.aws_s3_account_public_access_block.pass_all_settings_enabled... running
      # resource.aws_s3_account_public_access_block.pass_all_settings_enabled... pass
      # resource.aws_s3_account_public_access_block.fail_block_public_acls_disabled... running
      # resource.aws_s3_account_public_access_block.fail_block_public_acls_disabled... pass
      # resource.aws_s3_account_public_access_block.fail_block_public_policy_disabled... running
      # resource.aws_s3_account_public_access_block.fail_block_public_policy_disabled... pass
      # resource.aws_s3_account_public_access_block.fail_ignore_public_acls_disabled... running
      # resource.aws_s3_account_public_access_block.fail_ignore_public_acls_disabled... pass
      # resource.aws_s3_account_public_access_block.fail_restrict_public_buckets_disabled... running
      # resource.aws_s3_account_public_access_block.fail_restrict_public_buckets_disabled... pass
      # resource.aws_s3_account_public_access_block.fail_all_settings_disabled... running
      # resource.aws_s3_account_public_access_block.fail_all_settings_disabled... pass
      # resource.aws_s3_account_public_access_block.fail_multiple_settings_disabled... running
      # resource.aws_s3_account_public_access_block.fail_multiple_settings_disabled... pass
      # resource.aws_s3_account_public_access_block.fail_settings_not_configured... running
      # resource.aws_s3_account_public_access_block.fail_settings_not_configured... pass
      # s3-account-level-public-access-blocks-periodic.policytest.hcl... pass
```

---
