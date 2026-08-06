# IAM policies should not allow full "*" administrative privileges

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure access management |

## Description

This control checks whether the default version of IAM policies (also known as customer managed policies) has administrator access by including a statement with `"Effect": "Allow"` with `"Action": "*"` over `"Resource": "*"`. The control fails if you have IAM policies with such a statement.

The control only checks the customer managed policies that you create. It does not check inline and AWS managed policies.

IAM policies define a set of privileges that are granted to users, groups, or roles. Following standard security advice, AWS recommends that you grant least privilege, which means to grant only the permissions that are required to perform a task. When you provide full administrative privileges instead of the minimum set of permissions that the user needs, you expose the resources to potentially unwanted actions.

Instead of allowing full administrative privileges, determine what users need to do and then craft policies that let the users perform only those tasks. It is more secure to start with a minimum set of permissions and grant additional permissions as necessary. Do not start with permissions that are too lenient and then try to tighten them later.

You should remove IAM policies that have a statement with `"Effect": "Allow"` with `"Action": "*"` over `"Resource": "*"`.

This rule is covered by the [iam-policy-no-statements-with-admin-access](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/iam/iam-policy-no-statements-with-admin-access.policy.hcl) policy.

## Policy Results

```bash
trace:
      # iam-policy-no-statements-with-admin-access.policytest.hcl...
      running
      # resource.aws_iam_policy.managed_policy_allows_admin...
      running
      # resource.aws_iam_policy.managed_policy_allows_admin...
      pass
      # resource.aws_iam_policy.managed_policy_read_only...
      running
      # resource.aws_iam_policy.managed_policy_read_only...
      pass
      # resource.aws_iam_policy.managed_policy_admin_action_list...
      running
      # resource.aws_iam_policy.managed_policy_admin_action_list...
      pass
      # resource.aws_iam_policy.managed_policy_admin_resource_list...
      running
      # resource.aws_iam_policy.managed_policy_admin_resource_list...
      pass
      # resource.aws_iam_policy.managed_policy_deny_admin...
      running
      # resource.aws_iam_policy.managed_policy_deny_admin...
      pass
      # resource.aws_iam_policy.permissions_boundary_policy_admin...
      running
      # resource.aws_iam_policy.permissions_boundary_policy_admin...
      pass
      # resource.aws_iam_role.role_with_boundary...
      running
      # resource.aws_iam_role.role_with_boundary...
      pass
      # iam-policy-no-statements-with-admin-access.policytest.hcl...
      pass
```

---