# CloudTrail Lake event data stores should be encrypted with customer managed AWS KMS keys

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks whether an AWS CloudTrail Lake event data store is encrypted with a customer-managed AWS KMS key. The control fails if the `kms_key_id` attribute is absent, null, or an empty string.

Encrypting CloudTrail Lake event data stores with customer-managed KMS keys gives you full control over the encryption keys used to protect your audit log data. Customer-managed keys allow you to define key usage policies, enable key rotation, audit key usage via AWS CloudTrail, and revoke access to the data by disabling or deleting the key. This separation of duties between data storage and key management helps meet compliance requirements for sensitive audit data.

This rule is covered by the [cloudtrail-lake-event-data-stores-should-be-encrypted-with-customer-managed-aws-kms-keys](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/cloudtrail/cloudtrail-lake-event-data-stores-should-be-encrypted-with-customer-managed-aws-kms-keys.policy.hcl) policy.

## Policy Results

```bash
trace:
      # cloudtrail-lake-event-data-stores-should-be-encrypted-with-customer-managed-aws-kms-keys.policytest.hcl...
      running
      # resource.aws_cloudtrail_event_data_store.pass_kms_arn...
      running
      # resource.aws_cloudtrail_event_data_store.pass_kms_arn...
      pass
      # resource.aws_cloudtrail_event_data_store.pass_kms_key_id...
      running
      # resource.aws_cloudtrail_event_data_store.pass_kms_key_id...
      pass
      # resource.aws_cloudtrail_event_data_store.pass_kms_alias...
      running
      # resource.aws_cloudtrail_event_data_store.pass_kms_alias...
      pass
      # resource.aws_cloudtrail_event_data_store.fail_missing_kms...
      running
      # resource.aws_cloudtrail_event_data_store.fail_missing_kms...
      pass
      # resource.aws_cloudtrail_event_data_store.fail_null_kms...
      running
      # resource.aws_cloudtrail_event_data_store.fail_null_kms...
      pass
      # resource.aws_cloudtrail_event_data_store.fail_empty_kms...
      running
      # resource.aws_cloudtrail_event_data_store.fail_empty_kms...
      pass
      # cloudtrail-lake-event-data-stores-should-be-encrypted-with-customer-managed-aws-kms-keys.policytest.hcl...
      pass
```

---
