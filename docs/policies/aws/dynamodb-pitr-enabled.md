# DynamoDB tables should have point-in-time recovery enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | DYNAMODB |

## Description

This control checks whether point-in-time recovery (PITR) is enabled for an Amazon DynamoDB table.

Backups help you to recover more quickly from a security incident. They also strengthen the resilience of your systems. DynamoDB point-in-time recovery automates backups for DynamoDB tables. It reduces the time to recover from accidental delete or write operations. DynamoDB tables that have PITR enabled can be restored to any point in time in the last 35 days.

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
