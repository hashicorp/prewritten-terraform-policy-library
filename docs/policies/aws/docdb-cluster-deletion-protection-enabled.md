# Amazon DocumentDB clusters should have deletion protection enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Data deletion protection |

## Description

This control checks whether an Amazon DocumentDB cluster has deletion protection enabled. The control fails if the cluster doesn't have deletion protection enabled.

Enabling cluster deletion protection offers an additional layer of protection against accidental database deletion or deletion by an unauthorized user. An Amazon DocumentDB cluster can't be deleted while deletion protection is enabled. You must first disable deletion protection before a delete request can succeed. Deletion protection is enabled by default when you create a cluster in the Amazon DocumentDB console.

This rule is covered by the [docdb-cluster-deletion-protection-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/docdb/docdb-cluster-deletion-protection-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # docdb-cluster-deletion-protection-enabled.policytest.hcl... running
      # resource.aws_docdb_cluster.pass_deletion_protection_enabled... running
      # resource.aws_docdb_cluster.pass_deletion_protection_enabled... pass
      # resource.aws_docdb_cluster.fail_deletion_protection_disabled... running
      # resource.aws_docdb_cluster.fail_deletion_protection_disabled... pass
      # resource.aws_docdb_cluster.fail_missing_deletion_protection... running
      # resource.aws_docdb_cluster.fail_missing_deletion_protection... pass
      # docdb-cluster-deletion-protection-enabled.policytest.hcl... pass
```

---
