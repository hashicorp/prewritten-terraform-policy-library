# Neptune DB clusters should publish audit logs to CloudWatch Logs

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether a Neptune DB cluster publishes audit logs to Amazon CloudWatch Logs. The control fails if a Neptune DB cluster doesn't publish audit logs to CloudWatch Logs. EnableCloudWatchLogsExport should be set to Audit.

Amazon Neptune and Amazon CloudWatch are integrated so that you can gather and analyze performance metrics. Neptune automatically sends metrics to CloudWatch and also supports CloudWatch Alarms. Audit logs are highly customizable. When you audit a database, each operation on the data can be monitored and logged to an audit trail, including information about which database cluster is accessed and how. We recommend sending these logs to CloudWatch to help you monitor your Neptune DB clusters.

This rule is covered by the [neptune-cluster-cloudwatch-log-export-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/neptune/neptune-cluster-cloudwatch-log-export-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # neptune-cluster-cloudwatch-log-export-enabled.policytest.hcl... running
      # resource.aws_neptune_cluster.pass_audit_only... running
      # resource.aws_neptune_cluster.pass_audit_only... pass
      # resource.aws_neptune_cluster.pass_audit_and_other... running
      # resource.aws_neptune_cluster.pass_audit_and_other... pass
      # resource.aws_neptune_cluster.pass_other_then_audit... running
      # resource.aws_neptune_cluster.pass_other_then_audit... pass
      # resource.aws_neptune_cluster.fail_other_only... running
      # resource.aws_neptune_cluster.fail_other_only... pass
      # resource.aws_neptune_cluster.fail_empty_logs... running
      # resource.aws_neptune_cluster.fail_empty_logs... pass
      # resource.aws_neptune_cluster.fail_missing_logs... running
      # resource.aws_neptune_cluster.fail_missing_logs... pass
      # neptune-cluster-cloudwatch-log-export-enabled.policytest.hcl... pass
```

---
