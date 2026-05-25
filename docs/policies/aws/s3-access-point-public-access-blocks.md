# S3 access points should have block public access settings enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resource not publicly accessible |

## Description

This control checks whether an Amazon S3 access point has block public access settings enabled. The control fails if block public access settings aren't enabled for the access point.

The Amazon S3 Block Public Access feature helps you manage access to your S3 resources at three levels: the account, bucket, and access point levels. The settings at each level can be configured independently, allowing you to have different levels of public access restrictions for your data. The access point settings can't individually override the more restrictive settings at higher levels (account level or bucket assigned to the access point). Instead, the settings at the access point level are additive, meaning they complement and work alongside the settings at the other levels. Unless you intend an S3 access point to be publicly accessible, you should enable block public access settings.

This rule is covered by the [s3-access-point-public-access-blocks](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/s3/s3-access-point-public-access-blocks.policy.hcl) policy.

## Policy Results

```bash
trace:
      # s3-access-point-public-access-blocks.policytest.hcl... running
      # resource.aws_s3_access_point.pass_all_settings_explicitly_enabled... running
      # resource.aws_s3_access_point.pass_all_settings_explicitly_enabled... pass
      # resource.aws_s3_access_point.pass_no_configuration_defaults_to_true... running
      # resource.aws_s3_access_point.pass_no_configuration_defaults_to_true... pass
      # resource.aws_s3_access_point.fail_block_public_acls_disabled... running
      # resource.aws_s3_access_point.fail_block_public_acls_disabled... pass
      # resource.aws_s3_access_point.fail_block_public_policy_disabled... running
      # resource.aws_s3_access_point.fail_block_public_policy_disabled... pass
      # resource.aws_s3_access_point.fail_ignore_public_acls_disabled... running
      # resource.aws_s3_access_point.fail_ignore_public_acls_disabled... pass
      # resource.aws_s3_access_point.fail_restrict_public_buckets_disabled... running
      # resource.aws_s3_access_point.fail_restrict_public_buckets_disabled... pass
      # resource.aws_s3_access_point.fail_multiple_settings_disabled... running
      # resource.aws_s3_access_point.fail_multiple_settings_disabled... pass
      # s3-access-point-public-access-blocks.policytest.hcl... pass
```

---
