# Ensure access to AWSCloudShellFullAccess is restricted

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure access management |

## Description

This control checks whether the `AWSCloudShellFullAccess` managed policy is attached to IAM users, groups, or roles.

CloudShell provides an authenticated shell running with the caller's credentials, and `AWSCloudShellFullAccess` includes the file upload and download actions. Together these turn the console session into a general-purpose data transfer channel that bypasses the network controls applied to normal workloads, which makes it an effective exfiltration route.

The policy rejects attachments of `AWSCloudShellFullAccess` to users, groups, and roles, and additionally rejects inline policies that allow `cloudshell:*`. Where CloudShell is genuinely needed, grant only the specific actions required.

This rule is covered by the [iam-restrict-cloudshell-access](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/iam/iam-restrict-cloudshell-access.policy.hcl) policy.

## Policy Results

```bash
trace:
      # iam-restrict-cloudshell-access.policytest.hcl... running
      # resource.aws_iam_user_policy_attachment.pass_other_managed_policy... running
      # resource.aws_iam_user_policy_attachment.pass_other_managed_policy... pass
      # resource.aws_iam_user_policy_attachment.fail_cloudshell_full_access... running
      # resource.aws_iam_user_policy_attachment.fail_cloudshell_full_access... pass
      # resource.aws_iam_group_policy_attachment.pass_other_managed_policy... running
      # resource.aws_iam_group_policy_attachment.pass_other_managed_policy... pass
      # resource.aws_iam_group_policy_attachment.fail_cloudshell_full_access... running
      # resource.aws_iam_group_policy_attachment.fail_cloudshell_full_access... pass
      # resource.aws_iam_role_policy_attachment.pass_other_managed_policy... running
      # resource.aws_iam_role_policy_attachment.pass_other_managed_policy... pass
      # resource.aws_iam_role_policy_attachment.fail_cloudshell_full_access... running
      # resource.aws_iam_role_policy_attachment.fail_cloudshell_full_access... pass
      # resource.aws_iam_user_policy.pass_specific_scalar_action... running
      # resource.aws_iam_user_policy.pass_specific_scalar_action... pass
      # resource.aws_iam_user_policy.fail_scalar_cloudshell_wildcard... running
      # resource.aws_iam_user_policy.fail_scalar_cloudshell_wildcard... pass
      # resource.aws_iam_group_policy.pass_deny_cloudshell_wildcard... running
      # resource.aws_iam_group_policy.pass_deny_cloudshell_wildcard... pass
      # resource.aws_iam_group_policy.fail_case_variant_list_wildcard... running
      # resource.aws_iam_group_policy.fail_case_variant_list_wildcard... pass
      # resource.aws_iam_role_policy.pass_specific_action_list... running
      # resource.aws_iam_role_policy.pass_specific_action_list... pass
      # resource.aws_iam_role_policy.fail_list_cloudshell_wildcard... running
      # resource.aws_iam_role_policy.fail_list_cloudshell_wildcard... pass
      # iam-restrict-cloudshell-access.policytest.hcl... pass
```

---
