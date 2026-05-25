# IAM root user access key should not exist

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure access management |

## Description

This control checks whether the root user access key is present.

The root user is the most privileged user in an AWS account. AWS access keys provide programmatic access to a given account.

Security Hub CSPM recommends that you remove all access keys that are associated with the root user. This limits that vectors that can be used to compromise your account. It also encourages the creation and use of role-based accounts that are least privileged.

This rule is covered by the [iam-root-access-key-check](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/iam/iam-root-access-key-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # iam-root-access-key-check.policytest.hcl...
      running
      # resource.aws_iam_access_key.standard_user_key...
      running
      # resource.aws_iam_access_key.standard_user_key...
      pass
      # resource.aws_iam_access_key.root_user_key...
      running
      # resource.aws_iam_access_key.root_user_key...
      pass
      # resource.aws_iam_access_key.missing_user_attribute...
      running
      # resource.aws_iam_access_key.missing_user_attribute...
      pass
      # iam-root-access-key-check.policytest.hcl...
      pass
```

---