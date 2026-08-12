# RDS for SQL Server DB instances should publish logs to CloudWatch Logs

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether an Amazon RDS for Microsoft SQL Server DB instance is configured to publish logs to Amazon CloudWatch Logs. The control fails if the RDS for SQL Server DB instance isn't configured to publish logs to CloudWatch Logs. You can optionally specify the types of logs that a DB instance should be configured to publish.

Database logging provides detailed records of requests made to an Amazon RDS DB instance. Publishing logs to CloudWatch Logs centralizes log management and helps you perform real-time analysis of log data. CloudWatch Logs retains logs in highly durable storage. In addition, you can use it to create alarms for specific errors that can occur, such as frequent restarts that are recorded in an error log. Similarly, you can create alarms for errors or warnings that are recorded in SQL Server agent logs related to SQL agent jobs.

This rule is covered by the [rds-sql-server-logs-to-cloudwatch](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/rds/rds-sql-server-logs-to-cloudwatch.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-sql-server-logs-to-cloudwatch.policytest.hcl... running
      # resource.aws_db_instance.pass_sql_logs_enabled... running
      # resource.aws_db_instance.pass_sql_logs_enabled... pass
      # resource.aws_db_instance.pass_sql_versioned_engine... running
      # resource.aws_db_instance.pass_sql_versioned_engine... pass
      # resource.aws_db_instance.fail_no_sql_logs_configured... running
      # resource.aws_db_instance.fail_no_sql_logs_configured... pass
      # resource.aws_db_instance.fail_empty_sql_logs_list... running
      # resource.aws_db_instance.fail_empty_sql_logs_list... pass
      # resource.aws_db_instance.pass_sql_all_log_type... running
      # resource.aws_db_instance.pass_sql_all_log_type... pass
      # resource.aws_db_instance.skip_mysql_instance... running
      # resource.aws_db_instance.skip_mysql_instance... pass
      # rds-sql-server-logs-to-cloudwatch.policytest.hcl... pass
```

---
