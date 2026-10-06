# S3 general purpose buckets should use cross-Region replication

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure access management |

## Description

This control checks whether an Amazon S3 general purpose bucket has cross-Region replication enabled. The control fails if the bucket doesn't have cross-Region replication enabled.

Replication is the automatic, asynchronous copying of objects across buckets in the same or different AWS Regions. Replication copies newly created objects and object updates from a source bucket to a destination bucket or buckets. AWS best practices recommend replication for source and destination buckets that are owned by the same AWS account. In addition to availability, you should consider other systems hardening settings.

This control produces a FAILED finding for a replication destination bucket if it doesn't have cross-region replication enabled. If there's a legitimate reason that the destination bucket doesn't need cross-region replication to be enabled, you can suppress findings for this bucket.

This rule is covered by the [s3-bucket-should-use-cross-region-replication](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/s3/s3-bucket-should-use-cross-region-replication.policy.hcl) policy.

## Policy Results

```bash
trace:
      # s3-bucket-should-use-cross-region-replication.policytest.hcl... running
      # resource.aws_s3_bucket.pass_replicated... running
      # resource.aws_s3_bucket.pass_replicated... pass
      # resource.aws_s3_bucket.fail_no_replication... running
      # resource.aws_s3_bucket.fail_no_replication... pass
      # resource.aws_s3_bucket.fail_disabled_rule... running
      # resource.aws_s3_bucket.fail_disabled_rule... pass
      # resource.aws_s3_bucket.fail_empty_rules... running
      # resource.aws_s3_bucket.fail_empty_rules... pass
      # resource.aws_s3_bucket.fail_other_bucket_replicated... running
      # resource.aws_s3_bucket.fail_other_bucket_replicated... pass
      # resource.aws_s3_bucket.fail_null_id... running
      # resource.aws_s3_bucket.fail_null_id... pass
      # resource.aws_s3_bucket.fail_missing_id... running
      # resource.aws_s3_bucket.fail_missing_id... pass
      # s3-bucket-should-use-cross-region-replication.policytest.hcl... pass
```

---