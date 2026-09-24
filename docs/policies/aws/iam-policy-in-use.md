# Ensure a support role has been created to manage incidents with AWS Support

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure access management |

## Description

This control checks whether the `AWSSupportAccess` managed policy is attached to an identity that can actually be used.

Opening and managing AWS Support cases requires explicit permissions. If no usable identity holds `AWSSupportAccess`, the workaround during an incident is to fall back on an over-privileged principal — often the root user — at exactly the moment when careful access control matters most.

Attaching the policy is not sufficient on its own: a group with no members grants nothing, and a role with no assumable trust policy cannot be entered. The policy requires that a group holding `AWSSupportAccess` contains at least one user, and that a role holding it declares a trusted principal together with an STS assume-role action in its `assume_role_policy`.

This rule is covered by the [iam-policy-in-use](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/iam/iam-policy-in-use.policy.hcl) policy.

## Policy Results

```bash
trace:
      # iam-policy-in-use.policytest.hcl... running
      # resource.aws_iam_group_policy_attachment.pass_group_with_user... running
      # resource.aws_iam_group_policy_attachment.pass_group_with_user... pass
      # resource.aws_iam_group_policy_attachment.fail_empty_group... running
      # resource.aws_iam_group_policy_attachment.fail_empty_group... pass
      # resource.aws_iam_group_policy_attachment.fail_missing_group_membership... running
      # resource.aws_iam_group_policy_attachment.fail_missing_group_membership... pass
      # resource.aws_iam_group_policy_attachment.pass_other_group_policy... running
      # resource.aws_iam_group_policy_attachment.pass_other_group_policy... pass
      # resource.aws_iam_role_policy_attachment.pass_trusted_role_attachment... running
      # resource.aws_iam_role_policy_attachment.pass_trusted_role_attachment... pass
      # resource.aws_iam_role_policy_attachment.fail_no_principal_attachment... running
      # resource.aws_iam_role_policy_attachment.fail_no_principal_attachment... pass
      # resource.aws_iam_role_policy_attachment.fail_no_assume_action_attachment... running
      # resource.aws_iam_role_policy_attachment.fail_no_assume_action_attachment... pass
      # resource.aws_iam_role_policy_attachment.fail_missing_role... running
      # resource.aws_iam_role_policy_attachment.fail_missing_role... pass
      # resource.aws_iam_role_policy_attachment.pass_saml_role_attachment... running
      # resource.aws_iam_role_policy_attachment.pass_saml_role_attachment... pass
      # resource.aws_iam_role_policy_attachment.pass_other_policy_role_attachment... running
      # resource.aws_iam_role_policy_attachment.pass_other_policy_role_attachment... pass
      # iam-policy-in-use.policytest.hcl... pass
```

---
