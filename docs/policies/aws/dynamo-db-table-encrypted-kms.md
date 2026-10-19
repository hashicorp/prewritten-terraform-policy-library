# DynamoDB tables should be encrypted with AWS KMS keys

| Provider | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This policy checks if Amazon DynamoDB table is encrypted with AWS Key Management Service (KMS). The policy fails if Amazon DynamoDB table is not encrypted with AWS KMS. It also fails if the KMS key is not in the allowed key list input.

The policy evaluates `aws_dynamodb_table` resources.

This rule is covered by the [dynamo-db-table-encrypted-kms](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/dynamo/dynamo-db-table-encrypted-kms.policy.hcl) policy.

## Policy Results

```bash
trace:
      # dynamo-db-table-encrypted-kms.policytest.hcl...
      running
      #
      resource.aws_dynamodb_table.pass_default_key_no_restriction...
      running
      #
      resource.aws_dynamodb_table.pass_default_key_no_restriction...
      pass
      #
      resource.aws_dynamodb_table.pass_explicit_key_no_restriction...
      running
      #
      resource.aws_dynamodb_table.pass_explicit_key_no_restriction...
      pass
      #
      resource.aws_dynamodb_table.pass_null_kms_key_no_restriction...
      running
      #
      resource.aws_dynamodb_table.pass_null_kms_key_no_restriction...
      pass
      # resource.aws_dynamodb_table.fail_missing_sse_block...
      running
      # resource.aws_dynamodb_table.fail_missing_sse_block...
      pass
      # resource.aws_dynamodb_table.fail_empty_sse_list...
      running
      # resource.aws_dynamodb_table.fail_empty_sse_list...
      pass
      # resource.aws_dynamodb_table.fail_sse_disabled...
      running
      # resource.aws_dynamodb_table.fail_sse_disabled...
      pass
      # resource.aws_dynamodb_table.fail_enabled_null...
      running
      # resource.aws_dynamodb_table.fail_enabled_null...
      pass
      #
      resource.aws_dynamodb_table.pass_key_in_allowed_list_f2...
      running
      #
      resource.aws_dynamodb_table.pass_key_in_allowed_list_f2...
      pass
      # dynamo-db-table-encrypted-kms.policytest.hcl...
      pass
```

---
