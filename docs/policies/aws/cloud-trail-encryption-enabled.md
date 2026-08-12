# CloudTrail should have encryption at-rest enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks whether CloudTrail is configured to use the server-side encryption (SSE) AWS KMS key encryption. The control fails if the KmsKeyId isn't defined.

For an added layer of security for your sensitive CloudTrail log files, you should use server-side encryption with AWS KMS keys (SSE-KMS) for your CloudTrail log files for encryption at rest. Note that by default, the log files delivered by CloudTrail to your buckets are encrypted by Amazon server-side encryption with Amazon S3-managed encryption keys (SSE-S3).

This rule is covered by the [cloud-trail-encryption-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/cloudtrail/cloud-trail-encryption-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # cloud-trail-encryption-enabled.policytest.hcl... running
      # resource.aws_cloudtrail.pass_encryption_enabled... running
      # resource.aws_cloudtrail.pass_encryption_enabled... pass
      # resource.aws_cloudtrail.fail_encryption_missing... running
      # resource.aws_cloudtrail.fail_encryption_missing... pass
      # resource.aws_cloudtrail.fail_encryption_empty... running
      # resource.aws_cloudtrail.fail_encryption_empty... pass
      # resource.aws_cloudtrail.pass_encryption_with_alias... running
      # resource.aws_cloudtrail.pass_encryption_with_alias... pass
      # cloud-trail-encryption-enabled.policytest.hcl... pass
```

---
