# Ensure access keys are not set up during initial user setup for all users that have a console password

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure access management |

## Description

This control checks whether an IAM user is created with both a console login profile and an access key.

Provisioning both credential types up front hands out programmatic access that nobody has asked for yet. Keys created this way are frequently never used and never rotated, while still being fully valid — a standing credential with no owner paying attention to it.

Credentials should be issued against a demonstrated need, not by default. The policy fails when an `aws_iam_user_login_profile` and an `aws_iam_access_key` are planned for the same user.

This rule is covered by the [iam-user-console-and-api-access-at-creation](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/iam/iam-user-console-and-api-access-at-creation.policy.hcl) policy.

## Policy Results

```bash
trace:
      # iam-user-console-and-api-access-at-creation.policytest.hcl... running
      # resource.aws_iam_user_login_profile.pass_without_access_key... running
      # resource.aws_iam_user_login_profile.pass_without_access_key... pass
      # resource.aws_iam_user_login_profile.pass_with_access_key_for_different_user... running
      # resource.aws_iam_user_login_profile.pass_with_access_key_for_different_user... pass
      # resource.aws_iam_user_login_profile.fail_with_access_key_for_same_user... running
      # resource.aws_iam_user_login_profile.fail_with_access_key_for_same_user... pass
      # resource.aws_iam_user_login_profile.pass_null_user... running
      # resource.aws_iam_user_login_profile.pass_null_user... pass
      # resource.aws_iam_user_login_profile.pass_empty_user... running
      # resource.aws_iam_user_login_profile.pass_empty_user... pass
      # iam-user-console-and-api-access-at-creation.policytest.hcl... pass
```

---
