# RDS for SQL Server DB instances should be encrypted in transit

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks whether a connection to an Amazon RDS for Microsoft SQL Server DB instance is encrypted in transit. The control fails if the rds.force_ssl parameter of the parameter group associated with the DB instance is set to 0 (off).

Data in transit refers to data that moves from one location to another, such as between nodes in a DB cluster or between a DB cluster and a client application. Data can move across the internet or within a private network. Encrypting data in transit reduces the risk of unauthorized users eavesdropping on network traffic.

This rule is covered by the [rds-sqlserver-encrypted-in-transit](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/rds/rds-sqlserver-encrypted-in-transit.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-sqlserver-encrypted-in-transit.policytest.hcl... running
      # resource.aws_db_instance.sqlserver_ssl_enabled... running
      # resource.aws_db_instance.sqlserver_ssl_enabled... pass
      # resource.aws_db_instance.sqlserver_ssl_disabled... running
      # resource.aws_db_instance.sqlserver_ssl_disabled... pass
      # resource.aws_db_instance.sqlserver_ssl_not_configured... running
      # resource.aws_db_instance.sqlserver_ssl_not_configured... pass
      # resource.aws_db_instance.mysql_instance... running
      # resource.aws_db_instance.mysql_instance... pass
      # resource.aws_db_instance.sqlserver_ex_ssl_enabled... running
      # resource.aws_db_instance.sqlserver_ex_ssl_enabled... pass
      # resource.aws_db_instance.sqlserver_web_ssl_enabled... running
      # resource.aws_db_instance.sqlserver_web_ssl_enabled... pass
      # resource.aws_db_instance.sqlserver_ee_ssl_with_other_params... running
      # resource.aws_db_instance.sqlserver_ee_ssl_with_other_params... pass
      # rds-sqlserver-encrypted-in-transit.policytest.hcl... pass
```

---
