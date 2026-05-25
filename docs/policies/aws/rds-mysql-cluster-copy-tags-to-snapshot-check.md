# RDS for MySQL DB clusters should be configured to copy tags to DB snapshots

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Tagging |

## Description

This control checks whether an Amazon RDS for MySQL DB cluster is configured to automatically copy tags to snapshots of the DB cluster when the snapshots are created. The control fails if the CopyTagsToSnapshot parameter is set to false for the RDS for MySQL DB cluster.

Copying tags to DB snapshots helps maintain proper resource tracking, governance, and cost allocation across backup resources. This enables consistent resource identification, access control, and compliance monitoring across both active databases and their snapshots. Properly tagged snapshots improve security operations by ensuring backup resources inherit the same metadata as their source databases.

This rule is covered by the [rds-mysql-cluster-copy-tags-to-snapshot-check](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/rds/rds-mysql-cluster-copy-tags-to-snapshot-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-mysql-cluster-copy-tags-to-snapshot-check.policytest.hcl... running
      # resource.aws_rds_cluster.compliant... running
      # resource.aws_rds_cluster.compliant... pass
      # resource.aws_rds_cluster.non_compliant... running
      # resource.aws_rds_cluster.non_compliant... pass
      # resource.aws_rds_cluster.missing_attribute... running
      # resource.aws_rds_cluster.missing_attribute... pass
      # resource.aws_rds_cluster.postgres... running
      # resource.aws_rds_cluster.postgres... pass
      # resource.aws_rds_cluster.compliant... running
      # resource.aws_rds_cluster.compliant... pass
      # resource.aws_rds_cluster.non_compliant... running
      # resource.aws_rds_cluster.non_compliant... pass
      # rds-mysql-cluster-copy-tags-to-snapshot-check.policytest.hcl... pass
```

---
