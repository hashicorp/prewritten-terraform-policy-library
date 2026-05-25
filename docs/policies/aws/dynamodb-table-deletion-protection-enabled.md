# DynamoDB tables should have deletion protection enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Data deletion protection |

## Description

This control checks whether an Amazon DynamoDB table has deletion protection enabled. The control fails if a DynamoDB table doesn't have deletion protection enabled.

You can protect a DynamoDB table from accidental deletion with the deletion protection property. Enabling this property for tables helps ensure that tables don't get accidentally deleted during regular table management operations by your administrators. This helps prevent disruption to your normal business operations.

This rule is covered by the [dynamodb-table-deletion-protection-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/dynamodb/dynamodb-table-deletion-protection-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # dynamodb-table-deletion-protection-enabled.policytest.hcl...
      running
      # resource.aws_dynamodb_table.compliant...
      running
      # resource.aws_dynamodb_table.compliant...
      pass
      # resource.aws_dynamodb_table.non_compliant_explicit...
      running
      # resource.aws_dynamodb_table.non_compliant_explicit...
      pass
      # resource.aws_dynamodb_table.non_compliant_default...
      running
      # resource.aws_dynamodb_table.non_compliant_default...
      pass
      # dynamodb-table-deletion-protection-enabled.policytest.hcl...
      pass
```

---
