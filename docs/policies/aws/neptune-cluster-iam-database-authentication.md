# Neptune DB clusters should have IAM database authentication enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Passwordless authentication |

## Description

This control checks if a Neptune DB cluster has IAM database authentication enabled. The control fails if IAM database authentication isn't enabled for a Neptune DB cluster.

IAM database authentication for Amazon Neptune database clusters removes the need to store user credentials within the database configuration because authentication is managed externally using IAM. When IAM database authentication is enabled, each request needs to be signed using AWS Signature Version 4.

This rule is covered by the [neptune-cluster-iam-database-authentication](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/neptune/neptune-cluster-iam-database-authentication.policy.hcl) policy.

## Policy Results

```bash
trace:
      # neptune-cluster-iam-database-authentication.policytest.hcl... running
      # resource.aws_neptune_cluster.pass_iam_auth_enabled... running
      # resource.aws_neptune_cluster.pass_iam_auth_enabled... pass
      # resource.aws_neptune_cluster.fail_iam_auth_disabled... running
      # resource.aws_neptune_cluster.fail_iam_auth_disabled... pass
      # resource.aws_neptune_cluster.fail_iam_auth_missing... running
      # resource.aws_neptune_cluster.fail_iam_auth_missing... pass
      # neptune-cluster-iam-database-authentication.policytest.hcl... pass
```

---
