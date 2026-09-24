# Ensure there is only one active access key available for any single user

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure access management |

## Description

This control checks whether an IAM user has more than one active access key.

Two simultaneously active keys double the number of long-lived secrets that can leak, and they make attribution ambiguous — CloudTrail shows which key was used, but if both are in circulation it is often unclear which system or person that represents. A second key is genuinely needed only for the brief overlap of a rotation.

The policy counts the active access keys planned for each user and fails when more than one is active at the same time.

This rule is covered by the [iam-user-single-access-key](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/iam/iam-user-single-access-key.policy.hcl) policy.

## Policy Results

```bash
trace:
      # iam-user-single-access-key.policytest.hcl... running
      # resource.aws_iam_user.single_active_key_user... running
      # resource.aws_iam_user.single_active_key_user... pass
      # resource.aws_iam_user.mixed_status_user... running
      # resource.aws_iam_user.mixed_status_user... pass
      # resource.aws_iam_user.no_keys_user... running
      # resource.aws_iam_user.no_keys_user... pass
      # resource.aws_iam_user.two_active_keys_user... running
      # resource.aws_iam_user.two_active_keys_user... pass
      # iam-user-single-access-key.policytest.hcl... pass
```

---
