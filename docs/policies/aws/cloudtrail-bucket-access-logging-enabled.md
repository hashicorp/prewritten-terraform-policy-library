# Ensure S3 bucket access logging is enabled on the CloudTrail S3 bucket

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether the S3 bucket that receives CloudTrail log files has server access logging enabled.

CloudTrail log files are the authoritative record of API activity in an account, which makes the bucket holding them a high-value target. S3 server access logging records every request made against that bucket, so any attempt to read, copy, or delete the trail data leaves its own independent trail. Without it, tampering with the log bucket can go unnoticed.

The policy requires each CloudTrail log bucket to have a corresponding logging configuration that names a target bucket.

This rule is covered by the [cloudtrail-bucket-access-logging-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/cloudtrail/cloudtrail-bucket-access-logging-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # cloudtrail-bucket-access-logging-enabled.policytest.hcl... running
      # resource.aws_cloudtrail.pass_matching_logging_bucket... running
      # resource.aws_cloudtrail.pass_matching_logging_bucket... pass
      # resource.aws_cloudtrail.fail_unlogged_bucket... running
      # resource.aws_cloudtrail.fail_unlogged_bucket... pass
      # resource.aws_cloudtrail.fail_missing_target_bucket... running
      # resource.aws_cloudtrail.fail_missing_target_bucket... pass
      # resource.aws_cloudtrail.fail_unresolved_bucket... running
      # resource.aws_cloudtrail.fail_unresolved_bucket... pass
      # cloudtrail-bucket-access-logging-enabled.policytest.hcl... pass
```

---
