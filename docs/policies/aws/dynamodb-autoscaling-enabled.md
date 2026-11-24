# DynamoDB tables should automatically scale capacity with demand

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | High availability |

## Description

This control checks whether an Amazon DynamoDB table can scale its read and write capacity as needed. The control fails if the table doesn't use on-demand capacity mode or provisioned mode with auto scaling configured. By default, this control only requires that one of these modes be configured, without regard to specific levels of read or write capacity. Optionally, you can provide custom parameter values to require specific levels of read and write capacity or target utilization.

Scaling capacity with demand avoids throttling exceptions, which helps to maintain availability of your applications. DynamoDB tables that use on-demand capacity mode are limited only by the DynamoDB throughput default table quotas. To raise these quotas, you can file a support ticket with Support. DynamoDB tables that use provisioned mode with auto scaling adjust the provisioned throughput capacity dynamically in response to traffic patterns. For more information about DynamoDB request throttling, see Request throttling and burst capacity in the Amazon DynamoDB Developer Guide.

This rule is covered by the [dynamodb-autoscaling-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/dynamo/dynamodb-autoscaling-enabled.policy.hcl) policy.

## Parameters

| Parameter | Description | Type | Default | Constraints |
| --- | --- | --- | --- | --- |
| `minProvisionedReadCapacity` | Minimum number of provisioned read capacity units for DynamoDB auto scaling | `number` | `0` | `{ min: 1, max: 40000, integer: true }` |
| `maxProvisionedReadCapacity` | The maximum number of units that should be provisioned with read capacity in the Auto Scaling group. | `number` | `0` | `{ min: 1, max: 40000, integer: true }` |
| `targetReadUtilization` | Target utilization percentage for read capacity | `number` | `0` | `{ min: 20, max: 90, integer: true }` |
| `minProvisionedWriteCapacity` | Minimum number of provisioned write capacity units for DynamoDB auto scaling | `number` | `0` | `{ min: 1, max: 40000, integer: true }` |
| `maxProvisionedWriteCapacity` | The maximum number of units that should be provisioned with write capacity in the Auto Scaling group. | `number` | `0` | `{ min: 1, max: 40000, integer: true }` |
| `targetWriteUtilization` | Target utilization percentage for write capacity | `number` | `0` | `{ min: 20, max: 90, integer: true }` |

## Policy Results

```bash
trace:
      # dynamodb-autoscaling-enabled.policytest.hcl...
      running
      # resource.aws_dynamodb_table.on_demand_table...
      running
      # resource.aws_dynamodb_table.on_demand_table...
      pass
      # resource.aws_dynamodb_table.provisioned_table...
      running
      # resource.aws_dynamodb_table.provisioned_table...
      pass
      # resource.aws_dynamodb_table.default_billing...
      running
      # resource.aws_dynamodb_table.default_billing...
      pass
      # dynamodb-autoscaling-enabled.policytest.hcl...
      pass
```

---
