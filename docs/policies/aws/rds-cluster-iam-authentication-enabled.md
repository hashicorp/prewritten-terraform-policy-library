# IAM authentication should be configured for RDS clusters

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Passwordless authentication |

## Description

This control checks whether an Amazon RDS DB cluster has IAM database authentication enabled.

IAM database authentication allows for password-free authentication to database instances. The authentication uses an authentication token. Network traffic to and from the database is encrypted using SSL. For more information, see IAM database authentication in the Amazon Aurora User Guide.

This rule is covered by the [rds-cluster-iam-authentication-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/rds/rds-cluster-iam-authentication-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-cluster-iam-authentication-enabled.policytest.hcl... running
      # resource.aws_rds_cluster.pass_iam_auth_enabled... running
      # resource.aws_rds_cluster.pass_iam_auth_enabled... pass
      # resource.aws_rds_cluster.fail_iam_auth_disabled... running
      # resource.aws_rds_cluster.fail_iam_auth_disabled... pass
      # resource.aws_rds_cluster.fail_iam_auth_not_set... running
      # resource.aws_rds_cluster.fail_iam_auth_not_set... pass
      # rds-cluster-iam-authentication-enabled.policytest.hcl... pass
```

---
