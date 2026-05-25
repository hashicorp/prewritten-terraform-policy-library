# RDS for MariaDB DB instances should publish logs to CloudWatch Logs

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether an Amazon RDS for MariaDB DB instance is configured to publish certain types of logs to Amazon CloudWatch Logs. The control fails if the MariaDB DB instance isn't configured to publish the logs to CloudWatch Logs. You can optionally specify which types of logs a MariaDB DB instance should be configured to publish.

Database logging provides detailed records of requests made to an Amazon RDS for MariaDB DB instance. Publishing logs to Amazon CloudWatch Logs centralizes log management and helps you perform real-time analysis of the log data. In addition, CloudWatch Logs retains the logs in durable storage, which can support security, access, and availability reviews and audits. With CloudWatch Logs, you can also create alarms and review metrics.

This rule is covered by the [mariadb-publish-logs-to-cloudwatch-logs](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/rds/mariadb-publish-logs-to-cloudwatch-logs.policy.hcl) policy.

## Policy Results

```bash
trace:
      # mariadb-publish-logs-to-cloudwatch-logs.policytest.hcl... running
      # resource.aws_db_instance.pass_with_required_logs... running
      # resource.aws_db_instance.pass_with_required_logs... pass
      # resource.aws_db_instance.pass_with_all_logs... running
      # resource.aws_db_instance.pass_with_all_logs... pass
      # resource.aws_db_instance.pass_audit_logs... running
      # resource.aws_db_instance.pass_audit_logs... pass
      # resource.aws_db_instance.pass_error_logs... running
      # resource.aws_db_instance.pass_error_logs... pass
      # resource.aws_db_instance.fail_no_sql_logs_configured... running
      # resource.aws_db_instance.fail_no_sql_logs_configured... pass
      # resource.aws_db_instance.fail_empty_logs... running
      # resource.aws_db_instance.fail_empty_logs... pass
      # resource.aws_db_instance.skip_non_mariadb_engine... running
      # resource.aws_db_instance.skip_non_mariadb_engine... pass
      # resource.aws_db_instance.fail_wrong_logs_only... running
      # resource.aws_db_instance.fail_wrong_logs_only... pass
      # mariadb-publish-logs-to-cloudwatch-logs.policytest.hcl... pass
```

---
