# ElastiCache clusters should not use the default subnet group

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure network configuration |

## Description

This control checks whether an ElastiCache cluster is configured with a custom subnet group. The control fails if CacheSubnetGroupName for an ElastiCache cluster has the value default.

When launching an ElastiCache cluster, a default subnet group is created if one doesn't exist already. The default group uses subnets from the default Virtual Private Cloud (VPC). We recommend using custom subnet groups that are more restrictive of the subnets that the cluster resides in, and the networking that the cluster inherits from the subnets.

This rule is covered by the [elasticache-subnet-group-check](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/elasticache/elasticache-subnet-group-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # elasticache-subnet-group-check.policytest.hcl... running
      # resource.aws_elasticache_cluster.pass_custom_subnet_group... running
      # resource.aws_elasticache_cluster.pass_custom_subnet_group... pass
      # resource.aws_elasticache_cluster.fail_explicit_default... running
      # resource.aws_elasticache_cluster.fail_explicit_default... pass
      # resource.aws_elasticache_cluster.fail_missing_subnet_group... running
      # resource.aws_elasticache_cluster.fail_missing_subnet_group... pass
      # resource.aws_elasticache_subnet_group.pass_custom_sg... running
      # resource.aws_elasticache_subnet_group.pass_custom_sg... pass
      # resource.aws_elasticache_cluster.fail_explicit_default_sg... running
      # resource.aws_elasticache_cluster.fail_explicit_default_sg... pass
      # resource.aws_elasticache_cluster.fail_missing_sg... running
      # resource.aws_elasticache_cluster.fail_missing_sg... pass
      # elasticache-subnet-group-check.policytest.hcl... pass
```

---
