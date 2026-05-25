# Firehose delivery streams should be encrypted at rest

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks whether an Amazon Data Firehose delivery stream is encrypted at rest with server-side encryption. This control fails if a Firehose delivery stream isn't encrypted at rest with server-side encryption.

Server-side encryption is a feature in Amazon Data Firehose delivery streams that automatically encrypts data before it's at rest by using a key created in AWS Key Management Service (AWS KMS). Data is encrypted before it's written to the Data Firehose stream storage layer, and decrypted after it’s retrieved from storage. This allows you to comply with regulatory requirements and enhance the security of your data.

This rule is covered by the [kinesis-firehose-delivery-stream-encrypted](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/kinesis/kinesis-firehose-delivery-stream-encrypted.policy.hcl) policy.

## Policy Results

```bash
trace:
      # kinesis-firehose-delivery-stream-encrypted.policytest.hcl...
      running
      # resource.aws_kinesis_firehose_delivery_stream.pass_encryption_enabled...
      running
      # resource.aws_kinesis_firehose_delivery_stream.pass_encryption_enabled...
      pass
      # resource.aws_kinesis_firehose_delivery_stream.fail_no_encryption_block...
      running
      # resource.aws_kinesis_firehose_delivery_stream.fail_no_encryption_block...
      pass
      # resource.aws_kinesis_firehose_delivery_stream.fail_encryption_disabled...
      running
      # resource.aws_kinesis_firehose_delivery_stream.fail_encryption_disabled...
      pass
      # resource.aws_kinesis_firehose_delivery_stream.pass_kinesis_source_exception...
      running
      # resource.aws_kinesis_firehose_delivery_stream.pass_kinesis_source_exception...
      pass
      # resource.aws_kinesis_firehose_delivery_stream.pass_aws_owned_cmk...
      running
      # resource.aws_kinesis_firehose_delivery_stream.pass_aws_owned_cmk...
      pass
      # resource.aws_kinesis_firehose_delivery_stream.pass_customer_managed_cmk...
      running
      # resource.aws_kinesis_firehose_delivery_stream.pass_customer_managed_cmk...
      pass
      # kinesis-firehose-delivery-stream-encrypted.policytest.hcl...
      pass
```

---
