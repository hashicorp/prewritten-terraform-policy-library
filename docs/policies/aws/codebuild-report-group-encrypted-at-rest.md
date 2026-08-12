# CodeBuild report group exports should be encrypted at rest

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks whether the test results of an AWS CodeBuild report group that are exported to an Amazon Simple Storage Service (Amazon S3) bucket are encrypted at rest. The control fails if the report group export isn't encrypted at rest.

Data at rest refers to data that's stored in persistent, non-volatile storage for any duration. Encrypting data at rest helps you protect its confidentiality, which reduces the risk that an unauthorized user can access it.

This rule is covered by the [codebuild-report-group-encrypted-at-rest](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/codebuild/codebuild-report-group-encrypted-at-rest.policy.hcl) policy.

## Policy Results

```bash
trace:
      # codebuild-report-group-encrypted-at-rest.policytest.hcl...
      running
      # resource.aws_codebuild_report_group.pass_with_kms_encryption...
      running
      # resource.aws_codebuild_report_group.pass_with_kms_encryption...
      pass
      # resource.aws_codebuild_report_group.fail_missing_encryption_key...
      running
      # resource.aws_codebuild_report_group.fail_missing_encryption_key...
      pass
      # resource.aws_codebuild_report_group.fail_encryption_disabled...
      running
      # resource.aws_codebuild_report_group.fail_encryption_disabled...
      pass
      # resource.aws_codebuild_report_group.fail_no_s3_destination...
      running
      # resource.aws_codebuild_report_group.fail_no_s3_destination...
      pass
      # resource.aws_codebuild_report_group.pass_no_export_filtered...
      running
      # resource.aws_codebuild_report_group.pass_no_export_filtered...
      pass
      # codebuild-report-group-encrypted-at-rest.policytest.hcl...
      pass
```

---
