# RDS instances should have automatic backups enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Backups enabled |

## Description

This control checks whether an Amazon Relational Database Service instance has automated backups enabled, and a backup retention period greater than or equal to the specified time frame. Read replicas are excluded from evaluation. The control fails if backups aren't enabled for the instance, or if the retention period is less than the specified time frame. Unless you provide a custom parameter value for the backup retention period, Security Hub CSPM uses a default value of 7 days.

Backups help you more quickly recover from a security incident and strengthens the resilience of your systems. Amazon RDS lets you configure daily full instance volume snapshots. For more information about Amazon RDS automated backups, see Working with Backups in the Amazon RDS User Guide.

This rule is covered by the [rds-db-instance-backup-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/rds/rds-db-instance-backup-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-db-instance-backup-enabled.policytest.hcl... running
      # resource.aws_db_instance.pass_retention_equals_default... running
      # resource.aws_db_instance.pass_retention_equals_default... pass
      # resource.aws_db_instance.pass_retention_14_days... running
      # resource.aws_db_instance.pass_retention_14_days... pass
      # resource.aws_db_instance.pass_retention_max... running
      # resource.aws_db_instance.pass_retention_max... pass
      # resource.aws_db_instance.fail_retention_6_days... running
      # resource.aws_db_instance.fail_retention_6_days... pass
      # resource.aws_db_instance.fail_retention_1_day... running
      # resource.aws_db_instance.fail_retention_1_day... pass
      # resource.aws_db_instance.fail_retention_0... running
      # resource.aws_db_instance.fail_retention_0... pass
      # resource.aws_db_instance.fail_missing_retention... running
      # resource.aws_db_instance.fail_missing_retention... pass
      # rds-db-instance-backup-enabled.policytest.hcl... pass
```

---
