# S3 general purpose buckets with versioning enabled should have Lifecycle configurations

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether an Amazon S3 general purpose versioned bucket has a Lifecycle configuration. The control fails if the bucket doesn't have a Lifecycle configuration.

We recommended creating a Lifecycle configuration for your S3 bucket to help you define actions that you want Amazon S3 to take during an object's lifetime.

This rule is covered by the [s3-bucket-with-versioning-should-have-lifecycle-configurations](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/s3/s3-bucket-with-versioning-should-have-lifecycle-configurations.policy.hcl) policy.

## Policy Results

```bash
trace:
      # s3-bucket-with-versioning-should-have-lifecycle-configurations.policytest.hcl... running
      # resource.aws_s3_bucket.pass_versioned_with_lifecycle... running
      # resource.aws_s3_bucket.pass_versioned_with_lifecycle... pass
      # resource.aws_s3_bucket.pass_versioning_suspended_no_lifecycle... running
      # resource.aws_s3_bucket.pass_versioning_suspended_no_lifecycle... pass
      # resource.aws_s3_bucket.pass_no_versioning_no_lifecycle... running
      # resource.aws_s3_bucket.pass_no_versioning_no_lifecycle... pass
      # resource.aws_s3_bucket.fail_versioned_without_lifecycle... running
      # resource.aws_s3_bucket.fail_versioned_without_lifecycle... pass
      # resource.aws_s3_bucket.fail_versioned_lifecycle_for_other_bucket... running
      # resource.aws_s3_bucket.fail_versioned_lifecycle_for_other_bucket... pass
      # s3-bucket-with-versioning-should-have-lifecycle-configurations.policytest.hcl... pass
```

---