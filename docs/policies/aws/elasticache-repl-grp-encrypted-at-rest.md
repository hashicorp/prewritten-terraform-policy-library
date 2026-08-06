# ElastiCache replication groups should be encrypted at rest

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks whether an ElastiCache replication group is encrypted at rest. The control fails if the replication group isn't encrypted at rest.

Encrypting data at rest reduces the risk that an unauthenticated user gets access to data that is stored on disk. ElastiCache (Redis OSS) replication groups should be encrypted at rest for an added layer of security.

This rule is covered by the [elasticache-repl-grp-encrypted-at-rest](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/elasticache/elasticache-repl-grp-encrypted-at-rest.policy.hcl) policy.

## Policy Results

```bash
trace:
      # elasticache-repl-grp-encrypted-at-rest.policytest.hcl... running
      # resource.aws_elasticache_replication_group.pass_redis_encrypted... running
      # resource.aws_elasticache_replication_group.pass_redis_encrypted... pass
      # resource.aws_elasticache_replication_group.pass_valkey_encrypted_explicit... running
      # resource.aws_elasticache_replication_group.pass_valkey_encrypted_explicit... pass
      # resource.aws_elasticache_replication_group.pass_valkey_encrypted_default... running
      # resource.aws_elasticache_replication_group.pass_valkey_encrypted_default... pass
      # resource.aws_elasticache_replication_group.pass_default_engine_encrypted... running
      # resource.aws_elasticache_replication_group.pass_default_engine_encrypted... pass
      # resource.aws_elasticache_replication_group.fail_redis_not_encrypted... running
      # resource.aws_elasticache_replication_group.fail_redis_not_encrypted... pass
      # resource.aws_elasticache_replication_group.fail_redis_missing_encryption... running
      # resource.aws_elasticache_replication_group.fail_redis_missing_encryption... pass
      # resource.aws_elasticache_replication_group.fail_valkey_encryption_disabled... running
      # resource.aws_elasticache_replication_group.fail_valkey_encryption_disabled... pass
      # resource.aws_elasticache_replication_group.fail_default_engine_missing_encryption... running
      # resource.aws_elasticache_replication_group.fail_default_engine_missing_encryption... pass
      # resource.aws_elasticache_replication_group.pass_valkey_encrypted_full_config... running
      # resource.aws_elasticache_replication_group.pass_valkey_encrypted_full_config... pass
      # elasticache-repl-grp-encrypted-at-rest.policytest.hcl... pass
```

---
