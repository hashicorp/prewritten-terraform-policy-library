# AWS KMS keys should not be deleted unintentionally

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Data deletion protection |

## Description

This control checks whether KMS keys are scheduled for deletion. The control fails if a KMS key is scheduled for deletion.

KMS keys cannot be recovered once deleted. Data encrypted under a KMS key is also permanently unrecoverable if the KMS key is deleted. If meaningful data has been encrypted under a KMS key scheduled for deletion, consider decrypting the data or re-encrypting the data under a new KMS key unless you are intentionally performing a cryptographic erasure.

When a KMS key is scheduled for deletion, a mandatory waiting period is enforced to allow time to reverse the deletion, if it was scheduled in error. The default waiting period is 30 days, but it can be reduced to as short as 7 days when the KMS key is scheduled for deletion. During the waiting period, the scheduled deletion can be canceled and the KMS key will not be deleted.

This rule is covered by the [kms-cmk-not-scheduled-for-deletion-2](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/kms/kms-cmk-not-scheduled-for-deletion-2.policy.hcl) policy.

## Policy Results

```bash
trace:
      # kms-cmk-not-scheduled-for-deletion-2.policytest.hcl...
      running
      # resource.aws_kms_key.compliant_enabled...
      running
      # resource.aws_kms_key.compliant_enabled...
      pass
      # resource.aws_kms_key.compliant_disabled...
      running
      # resource.aws_kms_key.compliant_disabled...
      pass
      # resource.aws_kms_key.non_compliant_pending_deletion...
      running
      # resource.aws_kms_key.non_compliant_pending_deletion...
      pass
      # resource.aws_kms_key.compliant_pending_import...
      running
      # resource.aws_kms_key.compliant_pending_import...
      pass
      # resource.aws_kms_key.compliant_unavailable...
      running
      # resource.aws_kms_key.compliant_unavailable...
      pass
      # kms-cmk-not-scheduled-for-deletion-2.policytest.hcl...
      pass
```

---