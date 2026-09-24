# Ensure users receive permissions only through groups

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure access management |

## Description

This control checks whether IAM users obtain their permissions through group membership.

Permissions attached directly to a user have to be reviewed one user at a time, and they drift as people change roles. Assigning permissions to groups keeps entitlements tied to a job function, so a single group change applies consistently and a single membership change fully describes what someone can do.

The policy requires every Terraform-managed IAM user to have an `aws_iam_user_group_membership` resource covering all groups named by the `iam-user-group-membership-check-group-names` input.

This rule is covered by the [iam-user-group-membership-check](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/iam/iam-user-group-membership-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # iam-user-group-membership-check.policytest.hcl... running
      # resource.aws_iam_user.matching_nonempty_membership... running
      # resource.aws_iam_user.matching_nonempty_membership... pass
      # resource.aws_iam_user.missing_membership... running
      # resource.aws_iam_user.missing_membership... pass
      # resource.aws_iam_user.membership_with_empty_groups... running
      # resource.aws_iam_user.membership_with_empty_groups... pass
      # resource.aws_iam_user.null_name... running
      # resource.aws_iam_user.null_name... pass
      # iam-user-group-membership-check.policytest.hcl... pass
```

---
