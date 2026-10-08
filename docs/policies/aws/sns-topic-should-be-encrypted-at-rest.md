# SNS topics should be encrypted at-rest using AWS KMS

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data at rest |

## Description

This control checks whether an Amazon SNS topic is encrypted at rest using keys managed in AWS Key Management Service (AWS KMS). The controls fails if the SNS topic doesn't use a KMS key for server-side encryption (SSE). By default, SNS stores messages and files using disk encryption. To pass this control, you must choose to use a KMS key for encryption instead. This adds an additional layer of security and provides more access control flexibility.

Encrypting data at rest reduces the risk of data stored on disk being accessed by a user not authenticated to AWS. API permissions are required to decrypt the data before it can be read. We recommend encrypting SNS topics with KMS keys for an added layer of security.

This rule is covered by the [sns-topic-should-be-encrypted-at-rest](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/sns/sns-topic-should-be-encrypted-at-rest.policy.hcl) policy.

## Policy Results

```bash
trace:
      # sns-topic-should-be-encrypted-at-rest.policytest.hcl... running
      # resource.aws_sns_topic.pass_custom_kms_key... running
      # resource.aws_sns_topic.pass_custom_kms_key... pass
      # resource.aws_sns_topic.pass_aws_managed_key... running
      # resource.aws_sns_topic.pass_aws_managed_key... pass
      # resource.aws_sns_topic.fail_missing_kms_key... running
      # resource.aws_sns_topic.fail_missing_kms_key... pass
      # resource.aws_sns_topic.fail_null_kms_key... running
      # resource.aws_sns_topic.fail_null_kms_key... pass
      # resource.aws_sns_topic.fail_empty_kms_key... running
      # resource.aws_sns_topic.fail_empty_kms_key... pass
      # sns-topic-should-be-encrypted-at-rest.policytest.hcl... pass
```

---