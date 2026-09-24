# Ensure an IAM user, IAM role or IAM group does not have an inline policy

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure access management |

## Description

This control checks whether IAM users, groups, or roles have inline policies attached.

An inline policy is embedded in the identity it belongs to. It cannot be reused, versioned, or rolled back, it does not show up in a central inventory of permissions, and it disappears silently when the identity is deleted. That makes inline grants the hardest permissions to audit and the easiest place for excess privilege to accumulate unnoticed.

Managed policies are standalone, versioned objects that can be reviewed once and attached many times. The policy rejects `aws_iam_user_policy`, `aws_iam_group_policy`, and `aws_iam_role_policy` resources, directing the permissions to an `aws_iam_policy` attached through the corresponding attachment resource.

This rule is covered by the [iam-no-inline-policy-check](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/iam/iam-no-inline-policy-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # iam-no-inline-policy-check.policytest.hcl... running
      # resource.aws_iam_policy.pass_no_inline_policies... running
      # resource.aws_iam_policy.pass_no_inline_policies... pass
      # resource.aws_iam_user_policy.fail_user_inline_policy_missing_optional_name... running
      # resource.aws_iam_user_policy.fail_user_inline_policy_missing_optional_name... pass
      # resource.aws_iam_group_policy.fail_group_inline_policy... running
      # resource.aws_iam_group_policy.fail_group_inline_policy... pass
      # resource.aws_iam_role_policy.fail_role_inline_policy... running
      # resource.aws_iam_role_policy.fail_role_inline_policy... pass
      # iam-no-inline-policy-check.policytest.hcl... pass
```

---
