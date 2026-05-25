# RDS database instances should use a custom administrator username

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resource Configuration |

## Description

This control checks whether you've changed the administrative username for Amazon Relational Database Service (Amazon RDS) database instances from the default value. The control fails if the administrative username is set to the default value. The control doesn't apply to engines of the type neptune (Neptune DB) or docdb (DocumentDB), and to RDS instances that are part of a cluster.

Default administrative usernames on Amazon RDS databases are public knowledge. When creating an Amazon RDS database, you should change the default administrative username to a unique value to reduce the risk of unintended access.

This rule is covered by the [rds-instance-default-admin-check](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/rds/rds-instance-default-admin-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-instance-default-admin-check.policytest.hcl... running
      # resource.aws_db_instance.pass_custom_username... running
      # resource.aws_db_instance.pass_custom_username... pass
      # resource.aws_db_instance.pass_custom_username_2... running
      # resource.aws_db_instance.pass_custom_username_2... pass
      # resource.aws_db_instance.fail_default_postgres... running
      # resource.aws_db_instance.fail_default_postgres... pass
      # resource.aws_db_instance.fail_default_admin... running
      # resource.aws_db_instance.fail_default_admin... pass
      # resource.aws_db_instance.fail_missing_username... running
      # resource.aws_db_instance.fail_missing_username... pass
      # rds-instance-default-admin-check.policytest.hcl... pass
```

---
