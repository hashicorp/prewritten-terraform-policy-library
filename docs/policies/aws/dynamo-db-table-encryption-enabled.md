# DynamoDB tables should be encrypted at rest

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This policy implements the AWS Config rule [dynamodb-table-encryption-enabled](https://docs.aws.amazon.com/config/latest/developerguide/dynamodb-table-encryption-enabled.html), which is part of the ISO/IEC 27001:2013 Annex A framework in AWS Audit Manager. Checks if the Amazon DynamoDB tables are encrypted and checks their status. The rule is COMPLIANT if the status is enabled or enabling.

The policy evaluates `aws_dynamodb_table` resources.

This rule is covered by the [dynamo-db-table-encryption-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/dynamo/dynamo-db-table-encryption-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      #
      dynamo-db-table-encryption-enabled.policytest.hcl...
      running
      # resource.aws_dynamodb_table.pass_default_encryption...
      running
      # resource.aws_dynamodb_table.pass_default_encryption...
      pass
      # resource.aws_dynamodb_table.pass_enabled_true...
      running
      # resource.aws_dynamodb_table.pass_enabled_true...
      pass
      # resource.aws_dynamodb_table.pass_enabled_false...
      running
      # resource.aws_dynamodb_table.pass_enabled_false...
      pass
      # resource.aws_dynamodb_table.pass_enabled_missing...
      running
      # resource.aws_dynamodb_table.pass_enabled_missing...
      pass
      # resource.aws_dynamodb_table.pass_enabled_null...
      running
      # resource.aws_dynamodb_table.pass_enabled_null...
      pass
      #
      dynamo-db-table-encryption-enabled.policytest.hcl...
      pass
```

---
