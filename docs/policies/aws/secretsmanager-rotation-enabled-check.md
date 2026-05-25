# Secrets Manager secrets should have automatic rotation enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure development |

## Description

Parameters:

| Parameter | Description | Type | Allowed custom values | Security Hub CSPM default value |
| --------- | ----------- | ---- | --------------------- | -------------------------------- |
| maximumAllowedRotationFrequency | Maximum number of days allowed for secret rotation frequency | Integer | 1 to 365 | No default value |

This control checks whether a secret stored in AWS Secrets Manager is configured with automatic rotation. The control fails if the secret isn't configured with automatic rotation. If you provide a custom value for the maximumAllowedRotationFrequency parameter, the control passes only if the secret is automatically rotated within the specified window of time.

Secrets Manager helps you improve the security posture of your organization. Secrets include database credentials, passwords, and third-party API keys. You can use Secrets Manager to store secrets centrally, encrypt secrets automatically, control access to secrets, and rotate secrets safely and automatically.

Secrets Manager can rotate secrets. You can use rotation to replace long-term secrets with short-term ones. Rotating your secrets limits how long an unauthorized user can use a compromised secret. For this reason, you should rotate your secrets frequently. To learn more about rotation, see Rotating your AWS Secrets Manager secrets in the AWS Secrets Manager User Guide.

This rule is covered by the [secretsmanager-rotation-enabled-check](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/secretsmanager/secretsmanager-rotation-enabled-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # secretsmanager-rotation-enabled-check.policytest.hcl...
      running
      # resource.aws_secretsmanager_secret.compliant_secret...
      running
      # resource.aws_secretsmanager_secret.compliant_secret...
      pass
      # resource.aws_secretsmanager_secret_rotation.compliant_secret...
      running
      # resource.aws_secretsmanager_secret_rotation.compliant_secret...
      pass
      # resource.aws_secretsmanager_secret.no_rotation_secret...
      running
      # resource.aws_secretsmanager_secret.no_rotation_secret...
      pass
      # resource.aws_secretsmanager_secret.threshold_secret...
      running
      # resource.aws_secretsmanager_secret.threshold_secret...
      pass
      # resource.aws_secretsmanager_secret_rotation.threshold_secret...
      running
      # resource.aws_secretsmanager_secret_rotation.threshold_secret...
      pass
      # resource.aws_secretsmanager_secret.excessive_frequency_secret...
      running
      # resource.aws_secretsmanager_secret.excessive_frequency_secret...
      pass
      # resource.aws_secretsmanager_secret_rotation.excessive_frequency_secret...
      running
      # resource.aws_secretsmanager_secret_rotation.excessive_frequency_secret...
      pass
      # resource.aws_secretsmanager_secret.rotation_no_frequency...
      running
      # resource.aws_secretsmanager_secret.rotation_no_frequency...
      pass
      # resource.aws_secretsmanager_secret_rotation.rotation_no_frequency...
      running
      # resource.aws_secretsmanager_secret_rotation.rotation_no_frequency...
      pass
      # secretsmanager-rotation-enabled-check.policytest.hcl...
      pass
```

---