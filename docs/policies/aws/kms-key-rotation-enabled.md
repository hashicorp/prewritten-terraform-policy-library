# Ensure rotation for customer-created symmetric CMKs is enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks whether automatic key rotation is enabled on customer-managed symmetric KMS keys.

The longer a key stays in use, the more ciphertext it protects and the larger the consequences if it is ever exposed. Annual rotation limits how much data any single key version covers, and because KMS retains previous versions and selects the right one transparently, older ciphertext stays readable with no re-encryption work.

Rotation applies to symmetric keys with KMS-managed key material; asymmetric keys and imported material are outside its scope and are excluded by the policy filter. The policy requires `enable_key_rotation` to be set to `true`.

This rule is covered by the [kms-key-rotation-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/kms/kms-key-rotation-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # kms-key-rotation-enabled.policytest.hcl... running
      # resource.aws_kms_key.pass_symmetric_rotation_enabled... running
      # resource.aws_kms_key.pass_symmetric_rotation_enabled... pass
      # resource.aws_kms_key.pass_omitted_key_spec_rotation_enabled... running
      # resource.aws_kms_key.pass_omitted_key_spec_rotation_enabled... pass
      # resource.aws_kms_key.pass_null_key_spec_rotation_enabled... running
      # resource.aws_kms_key.pass_null_key_spec_rotation_enabled... pass
      # resource.aws_kms_key.pass_empty_key_spec_rotation_enabled... running
      # resource.aws_kms_key.pass_empty_key_spec_rotation_enabled... pass
      # resource.aws_kms_key.fail_symmetric_rotation_disabled... running
      # resource.aws_kms_key.fail_symmetric_rotation_disabled... pass
      # resource.aws_kms_key.fail_symmetric_rotation_omitted... running
      # resource.aws_kms_key.fail_symmetric_rotation_omitted... pass
      # resource.aws_kms_key.fail_symmetric_rotation_null... running
      # resource.aws_kms_key.fail_symmetric_rotation_null... pass
      # resource.aws_kms_key.pass_asymmetric_key_excluded... running
      # resource.aws_kms_key.pass_asymmetric_key_excluded... pass
      # kms-key-rotation-enabled.policytest.hcl... pass
```

---
