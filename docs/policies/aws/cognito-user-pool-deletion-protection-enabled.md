# Cognito user pools should have deletion protection enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Data deletion protection |

## Description

This control checks whether an Amazon Cognito user pool has deletion protection enabled. The control fails if deletion protection is disabled for the user pool.

Deletion protection helps ensure that your user pool is not accidentally deleted. When you configure a user pool with deletion protection, the pool cannot be deleted by any user. Deletion protection prevents you from requesting the deletion of a user pool unless you first modify the pool and deactivate deletion protection.

This rule is covered by the [cognito-user-pool-deletion-protection-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/cognito/cognito-user-pool-deletion-protection-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # cognito-user-pool-deletion-protection-enabled.policytest.hcl...
      running
      # resource.aws_cognito_user_pool.compliant...
      running
      # resource.aws_cognito_user_pool.compliant...
      pass
      # resource.aws_cognito_user_pool.non_compliant_inactive...
      running
      # resource.aws_cognito_user_pool.non_compliant_inactive...
      pass
      # resource.aws_cognito_user_pool.non_compliant_missing...
      running
      # resource.aws_cognito_user_pool.non_compliant_missing...
      pass
      # cognito-user-pool-deletion-protection-enabled.policytest.hcl...
      pass
```

---
