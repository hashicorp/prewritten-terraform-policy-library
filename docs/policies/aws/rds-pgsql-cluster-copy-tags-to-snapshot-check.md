# RDS for PostgreSQL DB clusters should be configured to copy tags to DB snapshots

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Tagging |

## Description

This control checks whether an Amazon RDS for PostgreSQL DB cluster is configured to automatically copy tags to snapshots of the DB cluster when the snapshots are created. The control fails if the CopyTagsToSnapshot parameter is set to false for the RDS for PostgreSQL DB cluster.

Copying tags to DB snapshots helps maintain proper resource tracking, governance, and cost allocation across backup resources. This enables consistent resource identification, access control, and compliance monitoring across both active databases and their snapshots. Properly tagged snapshots improve security operations by ensuring backup resources inherit the same metadata as their source databases.

This rule is covered by the [rds-pgsql-cluster-copy-tags-to-snapshot-check](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/rds/rds-pgsql-cluster-copy-tags-to-snapshot-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-pgsql-cluster-copy-tags-to-snapshot-check.policytest.hcl... running
      # resource.aws_rds_cluster.pass_postgres_copy_tags_enabled... running
      # resource.aws_rds_cluster.pass_postgres_copy_tags_enabled... pass
      # resource.aws_rds_cluster.pass_aurora_postgres_copy_tags_enabled... running
      # resource.aws_rds_cluster.pass_aurora_postgres_copy_tags_enabled... pass
      # resource.aws_rds_cluster.fail_postgres_copy_tags_disabled... running
      # resource.aws_rds_cluster.fail_postgres_copy_tags_disabled... pass
      # resource.aws_rds_cluster.fail_aurora_postgres_copy_tags_disabled... running
      # resource.aws_rds_cluster.fail_aurora_postgres_copy_tags_disabled... pass
      # resource.aws_rds_cluster.fail_postgres_copy_tags_missing... running
      # resource.aws_rds_cluster.fail_postgres_copy_tags_missing... pass
      # resource.aws_rds_cluster.filter_mysql_cluster... running
      # resource.aws_rds_cluster.filter_mysql_cluster... pass
      # rds-pgsql-cluster-copy-tags-to-snapshot-check.policytest.hcl... pass
```

---
