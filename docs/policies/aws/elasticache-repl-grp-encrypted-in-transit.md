# ElastiCache replication groups should be encrypted in transit

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks whether an ElastiCache replication group is encrypted in transit. The control fails if the replication group isn't encrypted in transit.

Encrypting data in transit reduces the risk that an unauthorized user can eavesdrop on network traffic. Enabling encryption in transit on an ElastiCache replication group encrypts your data whenever it's moving from one place to another, such as between nodes in your cluster or between your cluster and your application.

This rule is covered by the [elasticache-repl-grp-encrypted-in-transit](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/elasticache/elasticache-repl-grp-encrypted-in-transit.policy.hcl) policy.

## Policy Results

```bash
trace:
      # elasticache-repl-grp-encrypted-in-transit.policytest.hcl... running
      # resource.aws_elasticache_replication_group.compliant... running
      # resource.aws_elasticache_replication_group.compliant... pass
      # resource.aws_elasticache_replication_group.non_compliant... running
      # resource.aws_elasticache_replication_group.non_compliant... pass
      # resource.aws_elasticache_replication_group.missing_attribute... running
      # resource.aws_elasticache_replication_group.missing_attribute... pass
      # elasticache-repl-grp-encrypted-in-transit.policytest.hcl... pass
```

---
