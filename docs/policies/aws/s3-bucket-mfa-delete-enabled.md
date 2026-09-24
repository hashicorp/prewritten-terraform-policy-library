# Ensure S3 general purpose buckets have MFA delete enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Data deletion protection |

## Description

This control checks whether S3 buckets have MFA delete enabled on their versioning configuration.

Versioning alone protects against accidental overwrites, but a caller holding valid credentials can still permanently remove object versions or switch versioning off. MFA delete requires a second factor for those two operations specifically, so a stolen access key is not by itself enough to destroy the version history.

The policy requires each bucket to have an `aws_s3_bucket_versioning` resource with `versioning_configuration.status` set to `Enabled` and `versioning_configuration.mfa_delete` set to `Enabled`.

This rule is covered by the [s3-bucket-mfa-delete-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/s3/s3-bucket-mfa-delete-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # s3-bucket-mfa-delete-enabled.policytest.hcl... running
      # resource.aws_s3_bucket.pass_mfa_delete_enabled... running
      # resource.aws_s3_bucket.pass_mfa_delete_enabled... pass
      # resource.aws_s3_bucket.pass_mfa_delete_with_tags... running
      # resource.aws_s3_bucket.pass_mfa_delete_with_tags... pass
      # resource.aws_s3_bucket.fail_no_versioning_resource... running
      # resource.aws_s3_bucket.fail_no_versioning_resource... pass
      # resource.aws_s3_bucket.fail_suspended_versioning... running
      # resource.aws_s3_bucket.fail_suspended_versioning... pass
      # resource.aws_s3_bucket.fail_mfa_delete_disabled... running
      # resource.aws_s3_bucket.fail_mfa_delete_disabled... pass
      # resource.aws_s3_bucket.fail_mfa_delete_omitted... running
      # resource.aws_s3_bucket.fail_mfa_delete_omitted... pass
      # resource.aws_s3_bucket.fail_mfa_delete_null... running
      # resource.aws_s3_bucket.fail_mfa_delete_null... pass
      # resource.aws_s3_bucket.fail_empty_versioning_config... running
      # resource.aws_s3_bucket.fail_empty_versioning_config... pass
      # s3-bucket-mfa-delete-enabled.policytest.hcl... pass
```

---
