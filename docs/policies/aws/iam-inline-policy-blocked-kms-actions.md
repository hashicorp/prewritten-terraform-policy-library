# IAM principals should not have IAM inline policies that allow decryption actions on all KMS keys

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure access management |

## Description

This control checks whether the inline policies that are embedded in your IAM identities (role, user, or group) allow the AWS KMS decryption and re-encryption actions on all KMS keys. The control fails if the policy is open enough to allow kms:Decrypt or kms:ReEncryptFrom actions on all KMS keys.

The control only checks KMS keys in the Resource element and doesn't take into account any conditionals in the Condition element of a policy.

With AWS KMS, you control who can use your KMS keys and gain access to your encrypted data. IAM policies define which actions an identity (user, group, or role) can perform on which resources. Following security best practices, AWS recommends that you allow least privilege. In other words, you should grant to identities only the permissions they need and only for keys that are required to perform a task. Otherwise, the user might use keys that are not appropriate for your data.

Instead of granting permission for all keys, determine the minimum set of keys that users need to access encrypted data. Then design policies that allow the users to use only those keys. For example, do not allow kms:Decrypt permission on all KMS keys. Instead, allow the permission only on specific keys in a specific Region for your account. By adopting the principle of least privilege, you can reduce the risk of unintended disclosure of your data.

This rule is covered by the [iam-inline-policy-blocked-kms-actions](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/kms/iam-inline-policy-blocked-kms-actions.policy.hcl) policy.

## Policy Results

```bash
trace:
      # iam-inline-policy-blocked-kms-actions.policytest.hcl... running
      # resource.aws_iam_user_policy.pass_user_specific_key... running
      # resource.aws_iam_user_policy.pass_user_specific_key... pass
      # resource.aws_iam_user_policy.fail_user_decrypt_all_keys... running
      # resource.aws_iam_user_policy.fail_user_decrypt_all_keys... pass
      # resource.aws_iam_role_policy.pass_role_specific_key... running
      # resource.aws_iam_role_policy.pass_role_specific_key... pass
      # resource.aws_iam_role_policy.fail_role_reencrypt_all_keys... running
      # resource.aws_iam_role_policy.fail_role_reencrypt_all_keys... pass
      # resource.aws_iam_group_policy.pass_group_specific_keys... running
      # resource.aws_iam_group_policy.pass_group_specific_keys... pass
      # resource.aws_iam_group_policy.fail_group_wildcard_all_keys... running
      # resource.aws_iam_group_policy.fail_group_wildcard_all_keys... pass
      # resource.aws_iam_user_policy.pass_user_encrypt_all_keys... running
      # resource.aws_iam_user_policy.pass_user_encrypt_all_keys... pass
      # resource.aws_iam_role_policy.fail_role_decrypt_string_all_keys... running
      # resource.aws_iam_role_policy.fail_role_decrypt_string_all_keys... pass
      # resource.aws_iam_group_policy.pass_group_multiple_specific_arns... running
      # resource.aws_iam_group_policy.pass_group_multiple_specific_arns... pass
      # resource.aws_iam_user_policy.pass_user_deny_decrypt_all_keys... running
      # resource.aws_iam_user_policy.pass_user_deny_decrypt_all_keys... pass
      # resource.aws_iam_role_policy.fail_role_multiple_actions_with_decrypt... running
      # resource.aws_iam_role_policy.fail_role_multiple_actions_with_decrypt... pass
      # resource.aws_iam_user_policy.fail_user_kms_wildcard_all_keys... running
      # resource.aws_iam_user_policy.fail_user_kms_wildcard_all_keys... pass
      # resource.aws_iam_role_policy.pass_role_decrypt_specific_key... running
      # resource.aws_iam_role_policy.pass_role_decrypt_specific_key... pass
      # resource.aws_iam_group_policy.fail_group_reencrypt_pattern_all_keys... running
      # resource.aws_iam_group_policy.fail_group_reencrypt_pattern_all_keys... pass
      # resource.aws_iam_user_policy.pass_user_mixed_actions... running
      # resource.aws_iam_user_policy.pass_user_mixed_actions... pass
      # resource.aws_iam_role_policy.pass_role_wildcard_specific_key... running
      # resource.aws_iam_role_policy.pass_role_wildcard_specific_key... pass
      # resource.aws_iam_group_policy.fail_group_multiple_blocked_all_keys... running
      # resource.aws_iam_group_policy.fail_group_multiple_blocked_all_keys... pass
      # resource.aws_iam_user_policy.pass_user_empty_actions... running
      # resource.aws_iam_user_policy.pass_user_empty_actions... pass
      # iam-inline-policy-blocked-kms-actions.policytest.hcl... pass
```

---
