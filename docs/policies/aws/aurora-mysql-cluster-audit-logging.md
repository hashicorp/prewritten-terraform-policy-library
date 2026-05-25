# Aurora MySQL DB clusters should have audit logging enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether an Amazon Aurora MySQL DB cluster has audit logging enabled. The control fails if the DB parameter group associated with the DB cluster is not in sync, the server_audit_logging parameter is not set to 1, or the server_audit_events parameter is set to an empty value.

Database logs can assist with security and access audits and help diagnose availability issues. Audit logs capture a record of database activity, including login attempts, data modifications, schema changes, and other events that can be audited for security and compliance purposes.

This rule is covered by the [aurora-mysql-cluster-audit-logging](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/rds/aurora-mysql-cluster-audit-logging.policy.hcl) policy.

## Policy Results

```bash
trace:
      # aurora-mysql-cluster-audit-logging.policytest.hcl... running
      # resource.aws_rds_cluster.pass_complete_audit_config... running
      # resource.aws_rds_cluster.pass_complete_audit_config... pass
      # resource.aws_rds_cluster.fail_no_parameter_group... running
      # resource.aws_rds_cluster.fail_no_parameter_group... pass
      # resource.aws_rds_cluster.fail_no_cloudwatch_export... running
      # resource.aws_rds_cluster.fail_no_cloudwatch_export... pass
      # resource.aws_rds_cluster.fail_audit_logging_disabled... running
      # resource.aws_rds_cluster.fail_audit_logging_disabled... pass
      # resource.aws_rds_cluster.fail_empty_audit_events... running
      # resource.aws_rds_cluster.fail_empty_audit_events... pass
      # resource.aws_rds_cluster.skip_aurora_postgresql... running
      # resource.aws_rds_cluster.skip_aurora_postgresql... pass
      # resource.aws_rds_cluster_parameter_group.skip_non_aurora_mysql_family... running
      # resource.aws_rds_cluster_parameter_group.skip_non_aurora_mysql_family... pass
      # resource.aws_rds_cluster.fail_missing_parameter_group_reference... running
      # resource.aws_rds_cluster.fail_missing_parameter_group_reference... pass
      # resource.aws_rds_cluster.pass_aurora_mysql_57... running
      # resource.aws_rds_cluster.pass_aurora_mysql_57... pass
      # aurora-mysql-cluster-audit-logging.policytest.hcl... pass
```

---
