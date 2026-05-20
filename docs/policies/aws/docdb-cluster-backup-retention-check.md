# Amazon DocumentDB clusters should have an adequate backup retention period

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Backups enabled |

## Description

This control checks whether an Amazon DocumentDB cluster has a backup retention period greater than or equal to the specified time frame. The control fails if the backup retention period is less than the specified time frame. Unless you provide a custom parameter value for the backup retention period, Security Hub CSPM uses a default value of 7 days.

Backups help you recover more quickly from a security incident and strengthen the resilience of your systems. By automating backups for your Amazon DocumentDB clusters, you'll be able to restore your systems to a point in time and minimize downtime and data loss. In Amazon DocumentDB, clusters have a default backup retention period of 1 day. This must be increased to a value between 7 and 35 days to pass this control.

This rule is covered by the [docdb-cluster-backup-retention-check](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/docdb/docdb-cluster-backup-retention-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # docdb-cluster-backup-retention-check.policytest.hcl... running
      # resource.aws_docdb_cluster.pass_retention_equals_default... running
      # resource.aws_docdb_cluster.pass_retention_equals_default... pass
      # resource.aws_docdb_cluster.pass_retention_14_days... running
      # resource.aws_docdb_cluster.pass_retention_14_days... pass
      # resource.aws_docdb_cluster.pass_retention_max... running
      # resource.aws_docdb_cluster.pass_retention_max... pass
      # resource.aws_docdb_cluster.fail_retention_6_days... running
      # resource.aws_docdb_cluster.fail_retention_6_days... pass
      # resource.aws_docdb_cluster.fail_retention_1_day... running
      # resource.aws_docdb_cluster.fail_retention_1_day... pass
      # resource.aws_docdb_cluster.fail_retention_0... running
      # resource.aws_docdb_cluster.fail_retention_0... pass
      # resource.aws_docdb_cluster.fail_missing_retention... running
      # resource.aws_docdb_cluster.fail_missing_retention... pass
      # docdb-cluster-backup-retention-check.policytest.hcl... pass
```

---
