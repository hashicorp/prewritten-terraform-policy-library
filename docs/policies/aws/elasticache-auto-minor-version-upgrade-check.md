# ElastiCache clusters should have automatic minor version upgrades enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Vulnerability, patch, and version management |

## Description

This control evaluates whether Amazon ElastiCache automatically applies minor version upgrades to a cache cluster. The control fails if the cache cluster doesn't have minor version upgrades automatically applied.

This control doesn't apply to ElastiCache Memcached clusters.

Automatic minor version upgrade is a feature that you can enable in Amazon ElastiCache to automatically upgrade your cache clusters when a new minor cache engine version is available. These upgrades might include security patches and bug fixes. Staying up-to-date with patch installation is an important step in securing systems.

This rule is covered by the [elasticache-auto-minor-version-upgrade-check](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/elasticache/elasticache-auto-minor-version-upgrade-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # elasticache-auto-minor-version-upgrade-check.policytest.hcl... running
      # resource.aws_elasticache_cluster.pass_redis_6_enabled... running
      # resource.aws_elasticache_cluster.pass_redis_6_enabled... pass
      # resource.aws_elasticache_cluster.pass_valkey_7_enabled... running
      # resource.aws_elasticache_cluster.pass_valkey_7_enabled... pass
      # resource.aws_elasticache_cluster.pass_missing_auto_minor_upgrade... running
      # resource.aws_elasticache_cluster.pass_missing_auto_minor_upgrade... pass
      # resource.aws_elasticache_cluster.fail_redis_6_disabled... running
      # resource.aws_elasticache_cluster.fail_redis_6_disabled... pass
      # resource.aws_elasticache_cluster.fail_valkey_7_disabled... running
      # resource.aws_elasticache_cluster.fail_valkey_7_disabled... pass
      # resource.aws_elasticache_cluster.pass_non_matching_engine... running
      # resource.aws_elasticache_cluster.pass_non_matching_engine... pass
      # resource.aws_elasticache_cluster.pass_missing_engine_version... running
      # resource.aws_elasticache_cluster.pass_missing_engine_version... pass
      # resource.aws_elasticache_cluster.pass_redis_below_6... running
      # resource.aws_elasticache_cluster.pass_redis_below_6... pass
      # elasticache-auto-minor-version-upgrade-check.policytest.hcl... pass
```

---
