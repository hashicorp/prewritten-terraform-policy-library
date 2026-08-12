# RDS instances should not use a database engine default port

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure network configuration |

## Description

This control checks whether an RDS cluster or instance uses a port other than the default port of the database engine. The control fails if the RDS cluster or instance uses the default port. This control doesn't apply to RDS instances that are part of a cluster.

If you use a known port to deploy an RDS cluster or instance, an attacker can guess information about the cluster or instance. The attacker can use this information in conjunction with other information to connect to an RDS cluster or instance or gain additional information about your application.

When you change the port, you must also update the existing connection strings that were used to connect to the old port. You should also check the security group of the DB instance to ensure that it includes an ingress rule that allows connectivity on the new port.

This rule is covered by the [rds-no-default-ports](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/rds/rds-no-default-ports.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-no-default-ports.policytest.hcl... running
      # resource.aws_db_instance.mysql_custom_port_pass... running
      # resource.aws_db_instance.mysql_custom_port_pass... pass
      # resource.aws_db_instance.mysql_no_port_fail... running
      # resource.aws_db_instance.mysql_no_port_fail... pass
      # resource.aws_db_instance.mysql_default_port_fail... running
      # resource.aws_db_instance.mysql_default_port_fail... pass
      # resource.aws_db_instance.postgres_custom_port_pass... running
      # resource.aws_db_instance.postgres_custom_port_pass... pass
      # resource.aws_db_instance.postgres_no_port_fail... running
      # resource.aws_db_instance.postgres_no_port_fail... pass
      # resource.aws_db_instance.oracle_custom_port_pass... running
      # resource.aws_db_instance.oracle_custom_port_pass... pass
      # resource.aws_db_instance.oracle_default_port_fail... running
      # resource.aws_db_instance.oracle_default_port_fail... pass
      # resource.aws_db_instance.sqlserver_custom_port_pass... running
      # resource.aws_db_instance.sqlserver_custom_port_pass... pass
      # resource.aws_db_instance.sqlserver_no_port_fail... running
      # resource.aws_db_instance.sqlserver_no_port_fail... pass
      # resource.aws_rds_cluster.aurora_mysql_custom_port_pass... running
      # resource.aws_rds_cluster.aurora_mysql_custom_port_pass... pass
      # resource.aws_rds_cluster.aurora_mysql_no_port_fail... running
      # resource.aws_rds_cluster.aurora_mysql_no_port_fail... pass
      # resource.aws_rds_cluster.aurora_postgres_custom_port_pass... running
      # resource.aws_rds_cluster.aurora_postgres_custom_port_pass... pass
      # resource.aws_rds_cluster.aurora_postgres_default_port_fail... running
      # resource.aws_rds_cluster.aurora_postgres_default_port_fail... pass
      # rds-no-default-ports.policytest.hcl... pass
```

---
