# Remove unused Secrets Manager secrets

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure access management |

## Description

Parameters:

| Parameter | Description | Type | Allowed custom values | Security Hub CSPM default value |
| --------- | ----------- | ---- | --------------------- | -------------------------------- |
| unusedForDays | Maximum number of days that a secret can remain unused | Integer | 1 to 365 | 90 |

This control checks whether an AWS Secrets Manager secret has been accessed within the specified time frame. The control fails if a secret is unused beyond the specified time frame. Unless you provide a custom parameter value for the access period, Security Hub CSPM uses a default value of 90 days.

Deleting unused secrets is as important as rotating secrets. Unused secrets can be abused by their former users, who no longer need access to these secrets. Also, as more users get access to a secret, someone might have mishandled and leaked it to an unauthorized entity, which increases the risk of abuse. Deleting unused secrets helps revoke secret access from users who no longer need it. It also helps to reduce the cost of using Secrets Manager. Therefore, it is essential to routinely delete unused secrets.

This rule is covered by the [secretsmanager-secret-unused](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/secretsmanager/secretsmanager-secret-unused.policy.hcl) policy.

## Policy Results

```bash
trace:
      # secretsmanager-secret-unused.policytest.hcl...
      running
      # resource.aws_secretsmanager_secret.pass_with_all_tracking_tags...
      running
      # resource.aws_secretsmanager_secret.pass_with_all_tracking_tags...
      pass
      # resource.aws_secretsmanager_secret.pass_with_last_accessed_tag...
      running
      # resource.aws_secretsmanager_secret.pass_with_last_accessed_tag...
      pass
      # resource.aws_secretsmanager_secret.pass_with_created_date_tag...
      running
      # resource.aws_secretsmanager_secret.pass_with_created_date_tag...
      pass
      # resource.aws_secretsmanager_secret.fail_without_tags...
      running
      # resource.aws_secretsmanager_secret.fail_without_tags...
      pass
      # resource.aws_secretsmanager_secret.fail_missing_tracking_tags...
      running
      # resource.aws_secretsmanager_secret.fail_missing_tracking_tags...
      pass
      # resource.aws_secretsmanager_secret.fail_with_empty_tags...
      running
      # resource.aws_secretsmanager_secret.fail_with_empty_tags...
      pass
      # resource.aws_secretsmanager_secret.skip_secret_being_deleted...
      running
      # resource.aws_secretsmanager_secret.skip_secret_being_deleted...
      pass
      # resource.aws_secretsmanager_secret.invalid_threshold_secret...
      running
      # resource.aws_secretsmanager_secret.invalid_threshold_secret...
      pass
      # secretsmanager-secret-unused.policytest.hcl...
      pass
```

---