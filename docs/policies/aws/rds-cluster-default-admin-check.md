# RDS Database clusters should use a custom administrator username

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resource Configuration |

## Description

This control checks whether an Amazon RDS database cluster has changed the admin username from its default value. The control does not apply to engines of the type neptune (Neptune DB) or docdb (DocumentDB). This rule will fail if the admin username is set to the default value.

When creating an Amazon RDS database, you should change the default admin username to a unique value. Default usernames are public knowledge and should be changed during RDS database creation. Changing the default usernames reduces the risk of unintended access.

This rule is covered by the [rds-cluster-default-admin-check](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/rds/rds-cluster-default-admin-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-cluster-default-admin-check.policytest.hcl... running
      # resource.aws_rds_cluster.pass_custom_username... running
      # resource.aws_rds_cluster.pass_custom_username... pass
      # resource.aws_rds_cluster.pass_custom_username_2... running
      # resource.aws_rds_cluster.pass_custom_username_2... pass
      # resource.aws_rds_cluster.fail_default_postgres... running
      # resource.aws_rds_cluster.fail_default_postgres... pass
      # resource.aws_rds_cluster.fail_default_admin... running
      # resource.aws_rds_cluster.fail_default_admin... pass
      # resource.aws_rds_cluster.fail_missing_username... running
      # resource.aws_rds_cluster.fail_missing_username... pass
      # rds-cluster-default-admin-check.policytest.hcl... pass
```

---
