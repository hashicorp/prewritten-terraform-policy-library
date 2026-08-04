# Amazon Aurora clusters should have backtracking enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Backups enabled |

## Description

This control checks whether an Amazon Aurora cluster has backtracking enabled. The control fails if the cluster doesn't have backtracking enabled. If you provide a custom value for the BacktrackWindowInHours parameter, the control passes only if the cluster is backtracked for the specified length of time.

Backups help you to recover more quickly from a security incident. They also strengthens the resilience of your systems. Aurora backtracking reduces the time to recover a database to a point in time. It does not require a database restore to do so.

This rule is covered by the [aurora-mysql-backtracking-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/rds/aurora-mysql-backtracking-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # aurora-mysql-backtracking-enabled.policytest.hcl... running
      # resource.aws_rds_cluster.pass_backtracking_24h... running
      # resource.aws_rds_cluster.pass_backtracking_24h... pass
      # resource.aws_rds_cluster.pass_backtracking_72h... running
      # resource.aws_rds_cluster.pass_backtracking_72h... pass
      # resource.aws_rds_cluster.fail_backtracking_disabled... running
      # resource.aws_rds_cluster.fail_backtracking_disabled... pass
      # resource.aws_rds_cluster.fail_backtracking_missing... running
      # resource.aws_rds_cluster.fail_backtracking_missing... pass
      # resource.aws_rds_cluster.fail_backtracking_exceeds_max... running
      # resource.aws_rds_cluster.fail_backtracking_exceeds_max... pass
      # resource.aws_rds_cluster.skip_aurora_postgresql... running
      # resource.aws_rds_cluster.skip_aurora_postgresql... pass
      # aurora-mysql-backtracking-enabled.policytest.hcl... pass
```

---
