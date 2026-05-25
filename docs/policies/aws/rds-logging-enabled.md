# RDS DB instances should publish logs to CloudWatch Logs

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether an Amazon RDS DB instance is configured to publish the following logs to Amazon CloudWatch Logs. The control fails if the instance isn’t configured to publish the following logs to CloudWatch Logs:

- Oracle: Alert, Audit, Trace, Listener
- PostgreSQL: Postgresql, Upgrade
- MySQL: Audit, Error, General, SlowQuery
- MariaDB: Audit, Error, General, SlowQuery
- SQL Server: Error, Agent
- Aurora: Audit, Error, General, SlowQuery
- Aurora-MySQL: Audit, Error, General, SlowQuery
- Aurora-PostgreSQL: Postgresql

RDS databases should have relevant logs enabled. Database logging provides detailed records of requests made to RDS. Database logs can assist with security and access audits and can help to diagnose availability issues.

This rule is covered by the [rds-logging-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/rds/rds-logging-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-logging-enabled.policytest.hcl... running
      # resource.aws_db_instance.mysql_compliant... running
      # resource.aws_db_instance.mysql_compliant... pass
      # resource.aws_db_instance.mysql_missing_required_logs... running
      # resource.aws_db_instance.mysql_missing_required_logs... pass
      # resource.aws_db_instance.postgres_compliant... running
      # resource.aws_db_instance.postgres_compliant... pass
      # resource.aws_db_instance.postgres_missing_upgrade... running
      # resource.aws_db_instance.postgres_missing_upgrade... pass
      # resource.aws_db_instance.sqlserver_compliant... running
      # resource.aws_db_instance.sqlserver_compliant... pass
      # resource.aws_db_instance.sqlserver_exports_omitted... running
      # resource.aws_db_instance.sqlserver_exports_omitted... pass
      # rds-logging-enabled.policytest.hcl... pass
```

---
