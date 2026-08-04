# ElastiCache (Redis OSS) clusters should have automatic backups enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Backups enabled |

## Description

This control evaluates whether an Amazon ElastiCache (Redis OSS) cluster has automatic backups enabled. The control fails if the SnapshotRetentionLimit for the Redis OSS cluster is less than the specified time period. Unless you provide a custom parameter value for the snapshot retention period, Security Hub CSPM uses a default value of 1 day.

ElastiCache (Redis OSS) clusters can back up their data. You can use the backup to restore a cluster or seed a new cluster. The backup consists of the cluster's metadata, along with all the data in the cluster. All backups are written to Amazon S3, which provides durable storage. You can restore your data by creating a new ElastiCache cluster and populating it with data from a backup. You can manage backups using the AWS Management Console, the AWS CLI, and the ElastiCache API.

This control also evaluates ElastiCache (Redis OSS and Valkey) replication groups.

This rule is covered by the [elasticache-redis-cluster-automatic-backup-check](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/elasticache/elasticache-redis-cluster-automatic-backup-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # elasticache-redis-cluster-automatic-backup-check.policytest.hcl... running
      # resource.aws_elasticache_cluster.pass_cluster_retention_15... running
      # resource.aws_elasticache_cluster.pass_cluster_retention_15... pass
      # resource.aws_elasticache_cluster.pass_cluster_retention_20... running
      # resource.aws_elasticache_cluster.pass_cluster_retention_20... pass
      # resource.aws_elasticache_cluster.fail_cluster_retention_1... running
      # resource.aws_elasticache_cluster.fail_cluster_retention_1... pass
      # resource.aws_elasticache_cluster.fail_cluster_retention_0... running
      # resource.aws_elasticache_cluster.fail_cluster_retention_0... pass
      # resource.aws_elasticache_cluster.fail_cluster_missing_retention... running
      # resource.aws_elasticache_cluster.fail_cluster_missing_retention... pass
      # resource.aws_elasticache_cluster.pass_cluster_non_redis_engine... running
      # resource.aws_elasticache_cluster.pass_cluster_non_redis_engine... pass
      # resource.aws_elasticache_replication_group.pass_rg_retention_15... running
      # resource.aws_elasticache_replication_group.pass_rg_retention_15... pass
      # resource.aws_elasticache_replication_group.pass_rg_retention_20... running
      # resource.aws_elasticache_replication_group.pass_rg_retention_20... pass
      # resource.aws_elasticache_replication_group.fail_rg_retention_1... running
      # resource.aws_elasticache_replication_group.fail_rg_retention_1... pass
      # resource.aws_elasticache_replication_group.fail_rg_retention_0... running
      # resource.aws_elasticache_replication_group.fail_rg_retention_0... pass
      # resource.aws_elasticache_replication_group.fail_rg_missing_retention... running
      # resource.aws_elasticache_replication_group.fail_rg_missing_retention... pass
      # resource.aws_elasticache_replication_group.pass_rg_non_redis_engine... running
      # resource.aws_elasticache_replication_group.pass_rg_non_redis_engine... pass
      # elasticache-redis-cluster-automatic-backup-check.policytest.hcl... pass
```

---
