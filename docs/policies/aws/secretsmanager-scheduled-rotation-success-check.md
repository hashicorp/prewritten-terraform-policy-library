# Secrets Manager secrets configured with automatic rotation should rotate successfully

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure development |

## Description

This control checks whether an AWS Secrets Manager secret rotated successfully based on the rotation schedule. The control fails if RotationOccurringAsScheduled is false. The control only evaluates secrets that have rotation turned on.

Secrets Manager helps you improve the security posture of your organization. Secrets include database credentials, passwords, and third-party API keys. You can use Secrets Manager to store secrets centrally, encrypt secrets automatically, control access to secrets, and rotate secrets safely and automatically.

Secrets Manager can rotate secrets. You can use rotation to replace long-term secrets with short-term ones. Rotating your secrets limits how long an unauthorized user can use a compromised secret. For this reason, you should rotate your secrets frequently.

In addition to configuring secrets to rotate automatically, you should ensure that those secrets rotate successfully based on the rotation schedule.

To learn more about rotation, see Rotating your AWS Secrets Manager secrets in the AWS Secrets Manager User Guide.

This rule is covered by the [secretsmanager-scheduled-rotation-success-check](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/secretmanager/secretsmanager-scheduled-rotation-success-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # secretsmanager-scheduled-rotation-success-check.policytest.hcl...
      running
      # resource.aws_secretsmanager_secret_rotation.pass_complete_config_auto_days...
      running
      # resource.aws_secretsmanager_secret_rotation.pass_complete_config_auto_days...
      pass
      # resource.aws_secretsmanager_secret_rotation.pass_complete_config_schedule_expr...
      running
      # resource.aws_secretsmanager_secret_rotation.pass_complete_config_schedule_expr...
      pass
      # resource.aws_secretsmanager_secret_rotation.fail_missing_rotation_rules...
      running
      # resource.aws_secretsmanager_secret_rotation.fail_missing_rotation_rules...
      pass
      # resource.aws_secretsmanager_secret_rotation.fail_empty_rotation_rules...
      running
      # resource.aws_secretsmanager_secret_rotation.fail_empty_rotation_rules...
      pass
      # resource.aws_secretsmanager_secret_rotation.fail_missing_lambda_arn...
      running
      # resource.aws_secretsmanager_secret_rotation.fail_missing_lambda_arn...
      pass
      # resource.aws_secretsmanager_secret_rotation.fail_no_schedule_in_rules...
      running
      # resource.aws_secretsmanager_secret_rotation.fail_no_schedule_in_rules...
      pass
      # resource.aws_secretsmanager_secret_rotation.pass_both_schedule_types...
      running
      # resource.aws_secretsmanager_secret_rotation.pass_both_schedule_types...
      pass
      # resource.aws_secretsmanager_secret_rotation.fail_empty_lambda_arn...
      running
      # resource.aws_secretsmanager_secret_rotation.fail_empty_lambda_arn...
      pass
      # secretsmanager-scheduled-rotation-success-check.policytest.hcl...
      pass
```

---