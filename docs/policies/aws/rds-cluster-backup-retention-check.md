# RDS DB clusters should have enough backup retention period set

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Backups enabled |

## Description

This control checks whether an RDS DB cluster has a minimum backup retention period. The control fails if the backup retention period is less than the specified parameter value. Unless you provide a custom parameter value, Security Hub uses a default value of 7 days.

This control checks whether an RDS DB cluster has a minimum backup retention period. The control fails if the backup retention period is less than the specified parameter value. Unless you provide a customer parameter value, Security Hub uses a default value of 7 days. This control applies to all types of RDS DB clusters including Aurora DB cluster, DocumentDB clusters, NeptuneDB clusters, etc.

This rule is covered by the [rds-cluster-backup-retention-check](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/rds/rds-cluster-backup-retention-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-cluster-backup-retention-check.policytest.hcl... running
      # resource.aws_rds_cluster.pass_cluster_retention_equals_default... running
      # resource.aws_rds_cluster.pass_cluster_retention_equals_default... pass
      # resource.aws_rds_cluster.pass_cluster_retention_14_days... running
      # resource.aws_rds_cluster.pass_cluster_retention_14_days... pass
      # resource.aws_rds_cluster.pass_cluster_retention_max... running
      # resource.aws_rds_cluster.pass_cluster_retention_max... pass
      # resource.aws_rds_cluster.fail_cluster_retention_6_days... running
      # resource.aws_rds_cluster.fail_cluster_retention_6_days... pass
      # resource.aws_rds_cluster.fail_cluster_retention_1_day... running
      # resource.aws_rds_cluster.fail_cluster_retention_1_day... pass
      # resource.aws_rds_cluster.fail_cluster_retention_0... running
      # resource.aws_rds_cluster.fail_cluster_retention_0... pass
      # resource.aws_rds_cluster.fail_cluster_missing_retention... running
      # resource.aws_rds_cluster.fail_cluster_missing_retention... pass
      # rds-cluster-backup-retention-check.policytest.hcl... pass
```

---
