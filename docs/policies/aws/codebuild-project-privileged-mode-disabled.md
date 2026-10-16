# CodeBuild project environments should not have privileged mode enabled

| Provider | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure access management |

## Description

This policy checks if an AWS CodeBuild project environment has privileged mode enabled. The policy fails for a CodeBuild project if ‘privilegedMode’ is set to ‘true’.

The policy evaluates `aws_codebuild_project` resources.

This rule is covered by the [codebuild-project-privileged-mode-disabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/codebuild/codebuild-project-privileged-mode-disabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      #
      codebuild-project-privileged-mode-disabled.policytest.hcl...
      running
      #
      resource.aws_codebuild_project.pass_privileged_mode_false...
      running
      #
      resource.aws_codebuild_project.pass_privileged_mode_false...
      pass
      #
      resource.aws_codebuild_project.fail_privileged_mode_true_not_exempted...
      running
      #
      resource.aws_codebuild_project.fail_privileged_mode_true_not_exempted...
      pass
      #
      resource.aws_codebuild_project.pass_privileged_mode_missing_attribute...
      running
      #
      resource.aws_codebuild_project.pass_privileged_mode_missing_attribute...
      pass
      #
      resource.aws_codebuild_project.pass_privileged_mode_null...
      running
      #
      resource.aws_codebuild_project.pass_privileged_mode_null...
      pass
      #
      resource.aws_codebuild_project.fail_privileged_mode_true_different_project_f2...
      running
      #
      resource.aws_codebuild_project.fail_privileged_mode_true_different_project_f2...
      pass
      #
      codebuild-project-privileged-mode-disabled.policytest.hcl...
      pass
```

---
