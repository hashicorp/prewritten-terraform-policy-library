# CodeBuild S3 logs should be encrypted

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks if Amazon S3 logs for an AWS CodeBuild project are encrypted. The control fails if encryption is deactivated for S3 logs for a CodeBuild project.

Encryption of data at rest is a recommended best practice to add a layer of access management around your data. Encrypting the logs at rest reduces the risk that a user not authenticated by AWS will access the data stored on disk. It adds another set of access controls to limit the ability of unauthorized users to access the data.

This rule is covered by the [codebuild-project-s3-logs-encrypted](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/codebuild/codebuild-project-s3-logs-encrypted.policy.hcl) policy.

## Policy Results

```bash
trace:
      # codebuild-project-s3-logs-encrypted.policytest.hcl...
      running
      # resource.aws_codebuild_project.s3_logs_enabled_encryption_default...
      running
      # resource.aws_codebuild_project.s3_logs_enabled_encryption_default...
      pass
      # resource.aws_codebuild_project.s3_logs_enabled_encryption_explicit_false...
      running
      # resource.aws_codebuild_project.s3_logs_enabled_encryption_explicit_false...
      pass
      # resource.aws_codebuild_project.s3_logs_enabled_encryption_disabled...
      running
      # resource.aws_codebuild_project.s3_logs_enabled_encryption_disabled...
      pass
      # resource.aws_codebuild_project.s3_logs_disabled...
      running
      # resource.aws_codebuild_project.s3_logs_disabled...
      pass
      # resource.aws_codebuild_project.no_logs_config...
      running
      # resource.aws_codebuild_project.no_logs_config...
      pass
      # resource.aws_codebuild_project.logs_config_no_s3_logs...
      running
      # resource.aws_codebuild_project.logs_config_no_s3_logs...
      pass
      # codebuild-project-s3-logs-encrypted.policytest.hcl...
      pass
```

---
