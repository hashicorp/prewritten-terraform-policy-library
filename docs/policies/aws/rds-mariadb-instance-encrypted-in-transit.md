# RDS for MariaDB DB instances should be encrypted in transit

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks whether connections to an Amazon RDS for MariaDB DB instance are encrypted in transit. The control fails if the DB parameter group associated with the DB instance is not in sync, or the require_secure_transport parameter of the parameter group is not set to ON.

This control doesn't evaluate Amazon RDS DB instances that use MariaDB versions earlier than version 10.5. The require_secure_transport parameter is supported only for MariaDB versions 10.5 and later.

Data in transit refers to data that moves from one location to another, such as between nodes in a DB cluster or between a DB cluster and a client application. Data can move across the internet or within a private network. Encrypting data in transit reduces the risk of unauthorized users eavesdropping on network traffic.

This rule is covered by the [rds-mariadb-instance-encrypted-in-transit](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/rds/rds-mariadb-instance-encrypted-in-transit.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-mariadb-instance-encrypted-in-transit.policytest.hcl... running
      # resource.aws_db_instance.pass_10_5_transport_1... running
      # resource.aws_db_instance.pass_10_5_transport_1... pass
      # resource.aws_db_instance.pass_10_6_transport_on... running
      # resource.aws_db_instance.pass_10_6_transport_on... pass
      # resource.aws_db_instance.fail_10_5_transport_disabled... running
      # resource.aws_db_instance.fail_10_5_transport_disabled... pass
      # resource.aws_db_instance.fail_10_5_missing_param... running
      # resource.aws_db_instance.fail_10_5_missing_param... pass
      # resource.aws_db_instance.pass_10_4_not_applicable... running
      # resource.aws_db_instance.pass_10_4_not_applicable... pass
      # resource.aws_db_instance.pass_11_0_transport_enabled... running
      # resource.aws_db_instance.pass_11_0_transport_enabled... pass
      # resource.aws_db_instance.fail_11_0_missing_param... running
      # resource.aws_db_instance.fail_11_0_missing_param... pass
      # rds-mariadb-instance-encrypted-in-transit.policytest.hcl... pass
```

---
