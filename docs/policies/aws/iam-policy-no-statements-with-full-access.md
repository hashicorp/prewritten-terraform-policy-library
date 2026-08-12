# IAM customer managed policies that you create should not allow wildcard actions for services

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure access management |

## Description

Parameters:

| Parameter | Value |
| --------- | ----- |
| excludePermissionBoundaryPolicy | True (not customizable) |

This control checks whether the IAM identity-based policies that you create have Allow statements that use the `*` wildcard to grant permissions for all actions on any service. The control fails if any policy statement includes `"Effect": "Allow"` with `"Action": "Service:*"`.

For example, the following statement in a policy results in a failed finding.

```json
"Statement": [
  {
    "Sid": "EC2-Wildcard",
    "Effect": "Allow",
    "Action": "ec2:*",
    "Resource": "*"
  }
]
```

The control also fails if you use `"Effect": "Allow"` with `"NotAction": "service:*"`. In that case, the `NotAction` element provides access to all of the actions in an AWS service, except for the actions specified in `NotAction`.

This control only applies to customer managed IAM policies. It does not apply to IAM policies that are managed by AWS.

When you assign permissions to AWS services, it is important to scope the allowed IAM actions in your IAM policies. You should restrict IAM actions to only those actions that are needed. This helps you to provision least privilege permissions. Overly permissive policies might lead to privilege escalation if the policies are attached to an IAM principal that might not require the permission.

In some cases, you might want to allow IAM actions that have a similar prefix, such as `DescribeFlowLogs` and `DescribeAvailabilityZones`. In these authorized cases, you can add a suffixed wildcard to the common prefix. For example, `ec2:Describe*`. This control passes if you use a prefixed IAM action with a suffixed wildcard. For example, the following statement in a policy results in a passed finding.

```json
"Statement": [
  {
    "Sid": "EC2-Wildcard",
    "Effect": "Allow",
    "Action": "ec2:Describe*",
    "Resource": "*"
  }
]
```

When you group related IAM actions in this way, you can also avoid exceeding the IAM policy size.

This rule is covered by the [iam-policy-no-statements-with-full-access](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/iam/iam-policy-no-statements-with-full-access.policy.hcl) policy.

## Policy Results

```bash
trace:
      # iam-policy-no-statements-with-full-access.policytest.hcl...
      running
      # resource.aws_iam_policy.managed_policy_wildcard_action_fails...
      running
      # resource.aws_iam_policy.managed_policy_wildcard_action_fails...
      pass
      # resource.aws_iam_role_policy.role_policy_notaction_wildcard_fails...
      running
      # resource.aws_iam_role_policy.role_policy_notaction_wildcard_fails...
      pass
      # resource.aws_iam_user_policy.user_policy_prefixed_wildcard_passes...
      running
      # resource.aws_iam_user_policy.user_policy_prefixed_wildcard_passes...
      pass
      # resource.aws_iam_group_policy.group_policy_specific_actions_passes...
      running
      # resource.aws_iam_group_policy.group_policy_specific_actions_passes...
      pass
      # resource.aws_iam_policy.permissions_boundary_policy_full_access_fails_by_default...
      running
      # resource.aws_iam_policy.permissions_boundary_policy_full_access_fails_by_default...
      pass
      # resource.aws_iam_role.role_with_permission_boundary_full_access...
      running
      # resource.aws_iam_role.role_with_permission_boundary_full_access...
      pass
      # iam-policy-no-statements-with-full-access.policytest.hcl...
      pass
      # iam-policy-no-statements-with-full-access.policytest.hcl...
      running
      # resource.aws_iam_policy.permissions_boundary_policy_full_access_excluded...
      running
      # resource.aws_iam_policy.permissions_boundary_policy_full_access_excluded...
      pass
      # resource.aws_iam_user.user_with_permission_boundary_excluded...
      running
      # resource.aws_iam_user.user_with_permission_boundary_excluded...
      pass
      # iam-policy-no-statements-with-full-access.policytest.hcl...
      pass
      # iam-policy-no-statements-with-full-access.policytest.hcl...
      running
      # resource.aws_iam_policy.invalid_exclude_permission_boundary_input...
      running
      # resource.aws_iam_policy.invalid_exclude_permission_boundary_input...
      pass
      # iam-policy-no-statements-with-full-access.policytest.hcl...
      pass
```

---