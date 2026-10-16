# IAM roles should have the required managed policies attached

| Provider | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure access management |

## Description

This policy checks if all managed policies specified in the list of managed policies are attached to the AWS Identity and Access Management (IAM) role. The policy fails if a managed policy is not attached to the IAM role.

The policy evaluates `aws_iam_role` resources.

This rule is covered by the [iam-managed-policy-should-be-attached-to-role](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/iam/iam-managed-policy-should-be-attached-to-role.policy.hcl) policy.

## Policy Results

```bash
trace:
      #
      iam-managed-policy-should-be-attached-to-role.policytest.hcl...
      running
      #
      resource.aws_iam_role.pass_no_requirements_no_attachments...
      running
      #
      resource.aws_iam_role.pass_no_requirements_no_attachments...
      pass
      #
      resource.aws_iam_role.pass_no_requirements_with_attachments...
      running
      #
      resource.aws_iam_role.pass_no_requirements_with_attachments...
      pass
      #
      resource.aws_iam_role.pass_role_with_required_policy_f2...
      running
      #
      resource.aws_iam_role.pass_role_with_required_policy_f2...
      pass
      #
      resource.aws_iam_role.pass_role_with_extra_attachment_f2...
      running
      #
      resource.aws_iam_role.pass_role_with_extra_attachment_f2...
      pass
      #
      resource.aws_iam_role.pass_role_with_both_required_policies_f3...
      running
      #
      resource.aws_iam_role.pass_role_with_both_required_policies_f3...
      pass
      #
      iam-managed-policy-should-be-attached-to-role.policytest.hcl...
      pass
```

---
