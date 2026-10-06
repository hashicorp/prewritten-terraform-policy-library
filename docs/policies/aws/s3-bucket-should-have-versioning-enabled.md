# S3 general purpose buckets should have versioning enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Data protection |

## Description

This control checks whether an Amazon S3 general purpose bucket has versioning enabled. The control fails if versioning is suspended for the bucket.

Versioning keeps multiple variants of an object in the same S3 bucket. You can use versioning to preserve, retrieve, and restore all versions of all objects stored in your S3 bucket. Versioning helps you recover from both unintended user actions and application failures.

This rule is covered by the [s3-bucket-should-have-versioning-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/s3/s3-bucket-should-have-versioning-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # s3-bucket-should-have-versioning-enabled.policytest.hcl... running
      # resource.aws_s3_bucket.pass_enabled... running
      # resource.aws_s3_bucket.pass_enabled... pass
      # resource.aws_s3_bucket.fail_no_versioning... running
      # resource.aws_s3_bucket.fail_no_versioning... pass
      # resource.aws_s3_bucket.fail_suspended... running
      # resource.aws_s3_bucket.fail_suspended... pass
      # resource.aws_s3_bucket.fail_disabled... running
      # resource.aws_s3_bucket.fail_disabled... pass
      # resource.aws_s3_bucket.fail_other_bucket_versioned... running
      # resource.aws_s3_bucket.fail_other_bucket_versioned... pass
      # resource.aws_s3_bucket.fail_missing_config... running
      # resource.aws_s3_bucket.fail_missing_config... pass
      # s3-bucket-should-have-versioning-enabled.policytest.hcl... pass
```

---