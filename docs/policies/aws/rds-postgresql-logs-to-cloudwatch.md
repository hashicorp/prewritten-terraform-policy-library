# RDS for PostgreSQL DB instances should publish logs to CloudWatch Logs

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether an Amazon RDS for PostgreSQL DB instance is configured to publish logs to Amazon CloudWatch Logs. The control fails if the PostgreSQL DB instance isn't configured to publish the log types mentioned in the logTypes parameter to CloudWatch Logs.

Database logging provides detailed records of requests made to an RDS instance. PostgreSQL generates event logs that contain useful information for administrators. Publishing these logs to CloudWatch Logs centralizes log management and helps you perform real-time analysis of the log data. CloudWatch Logs retains logs in highly durable storage. You can also create alarms and view metrics in CloudWatch.

This rule is covered by the [rds-postgresql-logs-to-cloudwatch](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/rds/rds-postgresql-logs-to-cloudwatch.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-postgresql-logs-to-cloudwatch.policytest.hcl... running
      # resource.aws_db_instance.pass_postgresql_logs_enabled... running
      # resource.aws_db_instance.pass_postgresql_logs_enabled... pass
      # resource.aws_db_instance.pass_postgres_versioned_engine... running
      # resource.aws_db_instance.pass_postgres_versioned_engine... pass
      # resource.aws_db_instance.fail_no_logs_configured... running
      # resource.aws_db_instance.fail_no_logs_configured... pass
      # resource.aws_db_instance.fail_empty_logs_list... running
      # resource.aws_db_instance.fail_empty_logs_list... pass
      # resource.aws_db_instance.fail_wrong_log_type... running
      # resource.aws_db_instance.fail_wrong_log_type... pass
      # resource.aws_db_instance.skip_mysql_instance... running
      # resource.aws_db_instance.skip_mysql_instance... pass
      # rds-postgresql-logs-to-cloudwatch.policytest.hcl... pass
```

---
