# IAM authentication should be configured for RDS instances

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Passwordless authentication |

## Description

This control checks whether an RDS DB instance has IAM database authentication enabled. The control fails if IAM authentication is not configured for RDS DB instances. This control only evaluates RDS instances with the following engine types: mysql, postgres, aurora, aurora-mysql, aurora-postgresql, and mariadb. An RDS instance must also be in one of the following states for a finding to be generated: available, backing-up, storage-optimization, or storage-full.

IAM database authentication allows authentication to database instances with an authentication token instead of a password. Network traffic to and from the database is encrypted using SSL. For more information, see IAM database authentication in the Amazon Aurora User Guide.

This rule is covered by the [rds-instance-iam-authentication-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/rds/rds-instance-iam-authentication-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-instance-iam-authentication-enabled.policytest.hcl... running
      # resource.aws_db_instance.mysql_iam_auth_enabled... running
      # resource.aws_db_instance.mysql_iam_auth_enabled... pass
      # resource.aws_db_instance.postgres_iam_auth_disabled... running
      # resource.aws_db_instance.postgres_iam_auth_disabled... pass
      # resource.aws_db_instance.sqlserver_out_of_scope... running
      # resource.aws_db_instance.sqlserver_out_of_scope... pass
      # rds-instance-iam-authentication-enabled.policytest.hcl... pass
```

---
