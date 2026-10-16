# CodeBuild projects should encrypt all artifacts

| Provider | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This policy checks if an AWS CodeBuild project has encryption enabled for all of its artifacts. The policy fails if 'encryptionDisabled' is set to 'true' for any primary or secondary (if present) artifact configurations.

The policy evaluates `aws_codebuild_project` resources.

This rule is covered by the [codebuild-project-artifact-encryption](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/codebuild/codebuild-project-artifact-encryption.policy.hcl) policy.

## Policy Results

```bash
trace:
      #
      codebuild-project-artifact-encryption.policytest.hcl...
      running
      # resource.aws_codebuild_project.pass_primary_encrypted...
      running
      # resource.aws_codebuild_project.pass_primary_encrypted...
      pass
      #
      resource.aws_codebuild_project.fail_primary_not_encrypted...
      running
      #
      resource.aws_codebuild_project.fail_primary_not_encrypted...
      pass
      #
      resource.aws_codebuild_project.pass_primary_encryption_disabled_omitted...
      running
      #
      resource.aws_codebuild_project.pass_primary_encryption_disabled_omitted...
      pass
      #
      resource.aws_codebuild_project.pass_no_artifacts_type_exempt...
      running
      #
      resource.aws_codebuild_project.pass_no_artifacts_type_exempt...
      pass
      #
      resource.aws_codebuild_project.fail_secondary_not_encrypted...
      running
      #
      resource.aws_codebuild_project.fail_secondary_not_encrypted...
      pass
      #
      resource.aws_codebuild_project.pass_secondary_encrypted...
      running
      #
      resource.aws_codebuild_project.pass_secondary_encrypted...
      pass
      #
      resource.aws_codebuild_project.pass_no_secondary_artifacts...
      running
      #
      resource.aws_codebuild_project.pass_no_secondary_artifacts...
      pass
      #
      resource.aws_codebuild_project.fail_multiple_secondary_one_unencrypted...
      running
      #
      resource.aws_codebuild_project.fail_multiple_secondary_one_unencrypted...
      pass
      #
      resource.aws_codebuild_project.pass_primary_encryption_disabled_null...
      running
      #
      resource.aws_codebuild_project.pass_primary_encryption_disabled_null...
      pass
      #
      codebuild-project-artifact-encryption.policytest.hcl...
      pass
```

---
