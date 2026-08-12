# ElastiCache replication groups should have automatic failover enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | High availability |

## Description

This control checks whether an ElastiCache replication groups has automatic failover enabled. The control fails if automatic failover isn't enabled for a replication group.

When automatic failover is enabled for a replication group, the role of primary node will automatically fail over to one of the read replicas. This failover and replica promotion ensure that you can resume writing to the new primary after promotion is complete, which reduces overall downtime in case of failure.

This rule is covered by the [elasticache-repl-grp-auto-failover-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/elasticache/elasticache-repl-grp-auto-failover-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # elasticache-repl-grp-auto-failover-enabled.policytest.hcl... running
      # resource.aws_elasticache_replication_group.pass_auto_failover_2_clusters... running
      # resource.aws_elasticache_replication_group.pass_auto_failover_2_clusters... pass
      # resource.aws_elasticache_replication_group.pass_auto_failover_3_clusters... running
      # resource.aws_elasticache_replication_group.pass_auto_failover_3_clusters... pass
      # resource.aws_elasticache_replication_group.fail_auto_failover_1_cluster... running
      # resource.aws_elasticache_replication_group.fail_auto_failover_1_cluster... pass
      # resource.aws_elasticache_replication_group.fail_auto_failover_disabled_2_clusters... running
      # resource.aws_elasticache_replication_group.fail_auto_failover_disabled_2_clusters... pass
      # resource.aws_elasticache_replication_group.fail_auto_failover_disabled_1_cluster... running
      # resource.aws_elasticache_replication_group.fail_auto_failover_disabled_1_cluster... pass
      # resource.aws_elasticache_replication_group.fail_missing_auto_failover... running
      # resource.aws_elasticache_replication_group.fail_missing_auto_failover... pass
      # resource.aws_elasticache_replication_group.fail_auto_failover_missing_num_clusters... running
      # resource.aws_elasticache_replication_group.fail_auto_failover_missing_num_clusters... pass
      # resource.aws_elasticache_replication_group.fail_both_missing... running
      # resource.aws_elasticache_replication_group.fail_both_missing... pass
      # resource.aws_elasticache_replication_group.fail_auto_failover_0_clusters... running
      # resource.aws_elasticache_replication_group.fail_auto_failover_0_clusters... pass
      # elasticache-repl-grp-auto-failover-enabled.policytest.hcl... pass
```

---
