# ElastiCache (Redis OSS) replication groups of earlier versions should have Redis OSS AUTH enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure access management |

## Description

This control checks whether an ElastiCache (Redis OSS) replication group has Redis OSS AUTH enabled. The control fails if the Redis OSS version of the replication group nodes is below 6.0 and AuthToken isn't in use.

When you use Redis authentication tokens, or passwords, Redis requires a password before allowing clients to run commands, which improves data security. For Redis 6.0 and later versions, we recommend using Role-Based Access Control (RBAC). Since RBAC is not supported for Redis versions earlier than 6.0, this control only evaluates versions which can't use the RBAC feature.

This rule is covered by the [elasticache-repl-grp-redis-auth-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/elasticache/elasticache-repl-grp-redis-auth-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # elasticache-repl-grp-redis-auth-enabled.policytest.hcl... running
      # resource.aws_elasticache_replication_group.pass_redis_auth_v6... running
      # resource.aws_elasticache_replication_group.pass_redis_auth_v6... pass
      # resource.aws_elasticache_replication_group.pass_redis_auth_v7... running
      # resource.aws_elasticache_replication_group.pass_redis_auth_v7... pass
      # resource.aws_elasticache_replication_group.pass_redis_auth_no_version... running
      # resource.aws_elasticache_replication_group.pass_redis_auth_no_version... pass
      # resource.aws_elasticache_replication_group.pass_redis_auth_v6_2_6... running
      # resource.aws_elasticache_replication_group.pass_redis_auth_v6_2_6... pass
      # resource.aws_elasticache_replication_group.fail_redis_no_auth_v6... running
      # resource.aws_elasticache_replication_group.fail_redis_no_auth_v6... pass
      # resource.aws_elasticache_replication_group.fail_redis_empty_auth_v6... running
      # resource.aws_elasticache_replication_group.fail_redis_empty_auth_v6... pass
      # resource.aws_elasticache_replication_group.fail_redis_auth_v5... running
      # resource.aws_elasticache_replication_group.fail_redis_auth_v5... pass
      # resource.aws_elasticache_replication_group.fail_redis_auth_v4... running
      # resource.aws_elasticache_replication_group.fail_redis_auth_v4... pass
      # resource.aws_elasticache_replication_group.fail_redis_no_auth_no_version... running
      # resource.aws_elasticache_replication_group.fail_redis_no_auth_no_version... pass
      # resource.aws_elasticache_replication_group.skip_memcached... running
      # resource.aws_elasticache_replication_group.skip_memcached... pass
      # resource.aws_elasticache_replication_group.pass_redis_auth_v7_0_7... running
      # resource.aws_elasticache_replication_group.pass_redis_auth_v7_0_7... pass
      # elasticache-repl-grp-redis-auth-enabled.policytest.hcl... pass
```

---
