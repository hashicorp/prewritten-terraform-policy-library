# RDS clusters should have deletion protection enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Data deletion protection |

## Description

This control checks whether an RDS DB cluster has deletion protection enabled. The control fails if an RDS DB cluster doesn't have deletion protection enabled.

This control is intended for RDS DB instances. However, it can also generate findings for Aurora DB instances, Neptune DB instances, and Amazon DocumentDB clusters. If these findings are not useful, then you can suppress them.

Enabling cluster deletion protection is an additional layer of protection against accidental database deletion or deletion by an unauthorized entity.

When deletion protection is enabled, an RDS cluster cannot be deleted. Before a deletion request can succeed, deletion protection must be disabled.

This rule is covered by the [rds-cluster-deletion-protection-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/rds/rds-cluster-deletion-protection-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-cluster-deletion-protection-enabled.policytest.hcl... running
      # resource.aws_rds_cluster.pass_cluster_deletion_protection... running
      # resource.aws_rds_cluster.pass_cluster_deletion_protection... pass
      # resource.aws_rds_cluster.fail_cluster_deletion_protection... running
      # resource.aws_rds_cluster.fail_cluster_deletion_protection... pass
      # resource.aws_rds_cluster.fail_cluster_deletion_protection_missing... running
      # resource.aws_rds_cluster.fail_cluster_deletion_protection_missing... pass
      # rds-cluster-deletion-protection-enabled.policytest.hcl... pass
```

---
