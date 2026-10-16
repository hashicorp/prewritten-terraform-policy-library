# Secrets Manager secrets should be encrypted with customer managed AWS KMS keys

| Provider | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This policy checks if all secrets in AWS Secrets Manager are encrypted using the AWS managed key (aws/secretsmanager) or a customer managed key that was created in AWS Key Management Service (AWS KMS). The policy passes if a secret is encrypted using a customer managed key. The policy fails if a secret is encrypted using aws/secretsmanager.

The policy evaluates `aws_secretsmanager_secret` resources.

This rule is covered by the [secretsmanager-secrets-encrypted-using-cmk](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/secretmanager/secretsmanager-secrets-encrypted-using-cmk.policy.hcl) policy.

## Policy Results

```bash
trace:
      #
      secretsmanager-secrets-encrypted-using-cmk.policytest.hcl...
      running
      #
      resource.aws_secretsmanager_secret.fail_missing_kms_key_id...
      running
      #
      resource.aws_secretsmanager_secret.fail_missing_kms_key_id...
      pass
      #
      resource.aws_secretsmanager_secret.fail_null_kms_key_id...
      running
      #
      resource.aws_secretsmanager_secret.fail_null_kms_key_id...
      pass
      #
      resource.aws_secretsmanager_secret.fail_empty_kms_key_id...
      running
      #
      resource.aws_secretsmanager_secret.fail_empty_kms_key_id...
      pass
      #
      resource.aws_secretsmanager_secret.fail_aws_managed_alias...
      running
      #
      resource.aws_secretsmanager_secret.fail_aws_managed_alias...
      pass
      #
      resource.aws_secretsmanager_secret.fail_aws_managed_name...
      running
      #
      resource.aws_secretsmanager_secret.fail_aws_managed_name...
      pass
      #
      resource.aws_secretsmanager_secret.fail_aws_managed_alias_prefix...
      running
      #
      resource.aws_secretsmanager_secret.fail_aws_managed_alias_prefix...
      pass
      #
      resource.aws_secretsmanager_secret.pass_customer_managed_key_no_allowlist...
      running
      #
      resource.aws_secretsmanager_secret.pass_customer_managed_key_no_allowlist...
      pass
      #
      resource.aws_secretsmanager_secret.pass_matches_allowlist_exact_f2...
      running
      #
      resource.aws_secretsmanager_secret.pass_matches_allowlist_exact_f2...
      pass
      #
      resource.aws_secretsmanager_secret.pass_matches_allowlist_suffix_f2...
      running
      #
      resource.aws_secretsmanager_secret.pass_matches_allowlist_suffix_f2...
      pass
      #
      secretsmanager-secrets-encrypted-using-cmk.policytest.hcl...
      pass
```

---
