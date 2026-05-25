# CloudTrail log file validation should be enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Data integrity |

## Description

This control checks whether log file integrity validation is enabled on a CloudTrail trail.

CloudTrail log file validation creates a digitally signed digest file that contains a hash of each log that CloudTrail writes to Amazon S3. You can use these digest files to determine whether a log file was changed, deleted, or unchanged after CloudTrail delivered the log.

Security Hub CSPM recommends that you enable file validation on all trails. Log file validation provides additional integrity checks of CloudTrail logs.

This rule is covered by the [cloud-trail-log-file-validation-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/cloudtrail/cloud-trail-log-file-validation-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # cloud-trail-log-file-validation-enabled.policytest.hcl... running
      # resource.aws_cloudtrail.pass_log_validation_enabled... running
      # resource.aws_cloudtrail.pass_log_validation_enabled... pass
      # resource.aws_cloudtrail.fail_log_validation_disabled... running
      # resource.aws_cloudtrail.fail_log_validation_disabled... pass
      # resource.aws_cloudtrail.fail_log_validation_missing... running
      # resource.aws_cloudtrail.fail_log_validation_missing... pass
      # cloud-trail-log-file-validation-enabled.policytest.hcl... pass
```

---
