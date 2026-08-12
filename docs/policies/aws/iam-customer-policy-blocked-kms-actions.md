# IAM customer managed policies should not allow decryption actions on all KMS keys

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure access management |

## Description

Parameters:

| Parameter | Value |
| --------- | ----- |
| blockedActionsPatterns | kms:ReEncryptFrom, kms:Decrypt (not customizable) |
| excludePermissionBoundaryPolicy | True (not customizable) |

Checks whether the default version of IAM customer managed policies allow principals to use the AWS KMS decryption actions on all resources. The control fails if the policy is open enough to allow `kms:Decrypt` or `kms:ReEncryptFrom` actions on all KMS keys.

The control only checks KMS keys in the `Resource` element and doesn't take into account any conditionals in the `Condition` element of a policy. In addition, the control evaluates both attached and unattached customer managed policies. It doesn't check inline policies or AWS managed policies.

With AWS KMS, you control who can use your KMS keys and gain access to your encrypted data. IAM policies define which actions an identity (user, group, or role) can perform on which resources. Following security best practices, AWS recommends that you allow least privilege. In other words, you should grant to identities only the `kms:Decrypt` or `kms:ReEncryptFrom` permissions and only for the keys that are required to perform a task. Otherwise, the user might use keys that are not appropriate for your data.

Instead of granting permissions for all keys, determine the minimum set of keys that users need to access encrypted data. Then design policies that allow users to use only those keys. For example, do not allow `kms:Decrypt` permission on all KMS keys. Instead, allow `kms:Decrypt` only on keys in a particular Region for your account. By adopting the principle of least privilege, you can reduce the risk of unintended disclosure of your data.

This rule is covered by the [iam-customer-policy-blocked-kms-actions](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/kms/iam-customer-policy-blocked-kms-actions.policy.hcl) policy.

## Policy Results

```bash
trace:
      # iam-customer-policy-blocked-kms-actions.policytest.hcl...
      running
      # resource.aws_iam_policy.pass_specific_key_arn...
      running
      # resource.aws_iam_policy.pass_specific_key_arn...
      pass
      # resource.aws_iam_policy.fail_decrypt_wildcard_string...
      running
      # resource.aws_iam_policy.fail_decrypt_wildcard_string...
      pass
      # resource.aws_iam_policy.fail_reencrypt_wildcard...
      running
      # resource.aws_iam_policy.fail_reencrypt_wildcard...
      pass
      # resource.aws_iam_policy.pass_both_actions_specific_arns...
      running
      # resource.aws_iam_policy.pass_both_actions_specific_arns...
      pass
      # resource.aws_iam_policy.fail_kms_wildcard_action...
      running
      # resource.aws_iam_policy.fail_kms_wildcard_action...
      pass
      # resource.aws_iam_policy.pass_encrypt_wildcard...
      running
      # resource.aws_iam_policy.pass_encrypt_wildcard...
      pass
      # resource.aws_iam_policy.fail_decrypt_in_action_list...
      running
      # resource.aws_iam_policy.fail_decrypt_in_action_list...
      pass
      # resource.aws_iam_policy.fail_wildcard_in_resource_list...
      running
      # resource.aws_iam_policy.fail_wildcard_in_resource_list...
      pass
      # resource.aws_iam_policy.pass_multiple_statements_compliant...
      running
      # resource.aws_iam_policy.pass_multiple_statements_compliant...
      pass
      # resource.aws_iam_policy.pass_deny_effect_not_checked...
      running
      # resource.aws_iam_policy.pass_deny_effect_not_checked...
      pass
      # iam-customer-policy-blocked-kms-actions.policytest.hcl...
      pass
```

---