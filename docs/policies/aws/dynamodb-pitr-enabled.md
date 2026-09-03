# DynamoDB Point-in-Time Recovery Enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | DYNAMODB |

## Description

No description available from AWS docs.

This rule is covered by the [dynamodb-pitr-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/dynamo/dynamodb-pitr-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # dynamodb-pitr-enabled.policytest.hcl...
      running
      # resource.aws_dynamodb_table.pass_pitr_explicitly_enabled...
      running
      # resource.aws_dynamodb_table.pass_pitr_explicitly_enabled...
      pass
      # resource.aws_dynamodb_table.fail_pitr_explicitly_disabled...
      running
      # resource.aws_dynamodb_table.fail_pitr_explicitly_disabled...
      pass
      # resource.aws_dynamodb_table.fail_pitr_block_missing...
      running
      # resource.aws_dynamodb_table.fail_pitr_block_missing...
      pass
      # resource.aws_dynamodb_table.fail_pitr_enabled_attribute_missing...
      running
      # resource.aws_dynamodb_table.fail_pitr_enabled_attribute_missing...
      pass
      # dynamodb-pitr-enabled.policytest.hcl...
      pass
```

---
