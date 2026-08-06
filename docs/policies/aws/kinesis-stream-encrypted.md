# Kinesis streams should be encrypted at rest

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks if Kinesis Data Streams are encrypted at rest with server-side encryption. This control fails if a Kinesis stream is not encrypted at rest with server-side encryption.

Server-side encryption is a feature in Amazon Kinesis Data Streams that automatically encrypts data before it's at rest by using an AWS KMS key. Data is encrypted before it's written to the Kinesis stream storage layer, and decrypted after it's retrieved from storage. As a result, your data is encrypted at rest within the Amazon Kinesis Data Streams service.

This rule is covered by the [kinesis-stream-encrypted](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/kinesis/kinesis-stream-encrypted.policy.hcl) policy.

## Policy Results

```bash
trace:
      # kinesis-stream-encrypted.policytest.hcl...
      running
      # resource.aws_kinesis_stream.pass_kms_with_key_id...
      running
      # resource.aws_kinesis_stream.pass_kms_with_key_id...
      pass
      # resource.aws_kinesis_stream.pass_kms_with_aws_managed_key...
      running
      # resource.aws_kinesis_stream.pass_kms_with_aws_managed_key...
      pass
      # resource.aws_kinesis_stream.fail_encryption_none...
      running
      # resource.aws_kinesis_stream.fail_encryption_none...
      pass
      # resource.aws_kinesis_stream.fail_no_encryption_type...
      running
      # resource.aws_kinesis_stream.fail_no_encryption_type...
      pass
      # resource.aws_kinesis_stream.fail_kms_without_key_id...
      running
      # resource.aws_kinesis_stream.fail_kms_without_key_id...
      pass
      # resource.aws_kinesis_stream.fail_kms_with_empty_key_id...
      running
      # resource.aws_kinesis_stream.fail_kms_with_empty_key_id...
      pass
      # kinesis-stream-encrypted.policytest.hcl...
      pass
```

---
