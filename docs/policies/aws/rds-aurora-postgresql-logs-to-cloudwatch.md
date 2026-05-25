# Aurora PostgreSQL DB clusters should publish logs to CloudWatch Logs

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether an Amazon Aurora PostgreSQL DB cluster is configured to publish logs to Amazon CloudWatch Logs. The control fails if the Aurora PostgreSQL DB cluster isn't configured to publish PostgreSQL logs to CloudWatch Logs.

Database logging provides detailed records of requests made to an RDS cluster. Aurora PostgreSQL generates event logs that contain useful information for administrators. Publishing these logs to CloudWatch Logs centralizes log management and helps you perform real-time analysis of the log data. CloudWatch Logs retains logs in highly durable storage. You can also create alarms and view metrics in CloudWatch.

This rule is covered by the [rds-aurora-postgresql-logs-to-cloudwatch](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/rds/rds-aurora-postgresql-logs-to-cloudwatch.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-aurora-postgresql-logs-to-cloudwatch.policytest.hcl... running
      # resource.aws_rds_cluster.pass_postgresql_logs_enabled... running
      # resource.aws_rds_cluster.pass_postgresql_logs_enabled... pass
      # resource.aws_rds_cluster.fail_no_logs_exports... running
      # resource.aws_rds_cluster.fail_no_logs_exports... pass
      # resource.aws_rds_cluster.fail_postgresql_not_included... running
      # resource.aws_rds_cluster.fail_postgresql_not_included... pass
      # resource.aws_rds_cluster.fail_empty_logs_exports... running
      # resource.aws_rds_cluster.fail_empty_logs_exports... pass
      # resource.aws_rds_cluster.pass_multiple_log_types... running
      # resource.aws_rds_cluster.pass_multiple_log_types... pass
      # resource.aws_rds_cluster.skip_aurora_mysql... running
      # resource.aws_rds_cluster.skip_aurora_mysql... pass
      # rds-aurora-postgresql-logs-to-cloudwatch.policytest.hcl... pass
```

---
