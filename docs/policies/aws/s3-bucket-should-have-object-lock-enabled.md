# S3 general purpose buckets should have Object Lock enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Data Protection |

## Description

This control checks whether Amazon S3 general purpose buckets have Object Lock enabled. If the optional `mode` input is set to one or more retention modes, the bucket must also have an associated `aws_s3_bucket_object_lock_configuration` with a matching `default_retention.mode`. By default, no retention mode is required.

S3 Object Lock helps prevent objects from being deleted or overwritten for a fixed amount of time or indefinitely. Object Lock uses a WORM (write-once-read-many) model, which helps you meet regulatory requirements that require WORM storage or that simply add an extra layer of protection against object changes or deletion. Both `COMPLIANCE` mode (objects cannot be overwritten or deleted by any user, including the root account) and `GOVERNANCE` mode (users with special permissions can adjust retention settings) satisfy this control.

This rule is covered by the [s3-bucket-should-have-object-lock-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/s3/s3-bucket-should-have-object-lock-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # s3-bucket-should-have-object-lock-enabled.policytest.hcl...
      running
      # resource.aws_s3_bucket.pass_lock_enabled_without_mode...
      running
      # resource.aws_s3_bucket.pass_lock_enabled_without_mode...
      pass
      # resource.aws_s3_bucket.pass_compliance...
      running
      # resource.aws_s3_bucket.pass_compliance...
      pass
      # resource.aws_s3_bucket.pass_governance...
      running
      # resource.aws_s3_bucket.pass_governance...
      pass
      # resource.aws_s3_bucket.pass_without_retention_mode...
      running
      # resource.aws_s3_bucket.pass_without_retention_mode...
      pass
      # resource.aws_s3_bucket.fail_lock_disabled...
      running
      # resource.aws_s3_bucket.fail_lock_disabled...
      pass
      # resource.aws_s3_bucket.fail_lock_enabled_missing...
      running
      # resource.aws_s3_bucket.fail_lock_enabled_missing...
      pass
      # s3-bucket-should-have-object-lock-enabled.policytest.hcl...
      pass
```

---
