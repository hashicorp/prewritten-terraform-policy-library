# Secrets Manager secrets should be rotated within a specified number of days

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure access management |

## Description

Parameters:

| Parameter | Description | Type | Allowed custom values | Security Hub CSPM default value |
| --------- | ----------- | ---- | --------------------- | -------------------------------- |
| maxDaysSinceRotation | Maximum number of days that a secret can remain unchanged | Integer | 1 to 180 | 90 |

This control checks whether an AWS Secrets Manager secret is rotated at least once within the specified time frame. The control fails if a secret isn't rotated at least this frequently. Unless you provide a custom parameter value for the rotation period, Security Hub CSPM uses a default value of 90 days.

Rotating secrets can help you to reduce the risk of an unauthorized use of your secrets in your AWS account. Examples include database credentials, passwords, third-party API keys, and even arbitrary text. If you do not change your secrets for a long period of time, the secrets are more likely to be compromised.

As more users get access to a secret, it can become more likely that someone mishandled and leaked it to an unauthorized entity. Secrets can be leaked through logs and cache data. They can be shared for debugging purposes and not changed or revoked once the debugging completes. For all these reasons, secrets should be rotated frequently.

You can configure automatic rotation for secrets in AWS Secrets Manager. With automatic rotation, you can replace long-term secrets with short-term ones, significantly reducing the risk of compromise. We recommend that you configure automatic rotation for your Secrets Manager secrets. For more information, see Rotating your AWS Secrets Manager secrets in the AWS Secrets Manager User Guide.

This rule is covered by the [secretsmanager-secret-periodic-rotation](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/secretsmanager/secretsmanager-secret-periodic-rotation.policy.hcl) policy.

## Policy Results

```bash
trace:
      # secretsmanager-secret-periodic-rotation.policytest.hcl...
      running
      # resource.aws_secretsmanager_secret_rotation.compliant_30d...
      running
      # resource.aws_secretsmanager_secret_rotation.compliant_30d...
      pass
      # resource.aws_secretsmanager_secret_rotation.compliant_90d...
      running
      # resource.aws_secretsmanager_secret_rotation.compliant_90d...
      pass
      # resource.aws_secretsmanager_secret_rotation.compliant_1d...
      running
      # resource.aws_secretsmanager_secret_rotation.compliant_1d...
      pass
      # resource.aws_secretsmanager_secret_rotation.non_compliant_120d...
      running
      # resource.aws_secretsmanager_secret_rotation.non_compliant_120d...
      pass
      # resource.aws_secretsmanager_secret_rotation.missing_auto_days...
      running
      # resource.aws_secretsmanager_secret_rotation.missing_auto_days...
      pass
      # resource.aws_secretsmanager_secret_rotation.compliant_custom_120d...
      running
      # resource.aws_secretsmanager_secret_rotation.compliant_custom_120d...
      pass
      # resource.aws_secretsmanager_secret_rotation.invalid_threshold_input...
      running
      # resource.aws_secretsmanager_secret_rotation.invalid_threshold_input...
      pass
      # secretsmanager-secret-periodic-rotation.policytest.hcl...
      pass
```

---