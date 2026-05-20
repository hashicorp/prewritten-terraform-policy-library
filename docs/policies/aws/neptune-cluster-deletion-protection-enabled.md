# Neptune DB clusters should have deletion protection enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Data deletion protection |

## Description

This control checks if a Neptune DB cluster has deletion protection enabled. The control fails if a Neptune DB cluster doesn't have deletion protection enabled.

Enabling cluster deletion protection offers an additional layer of protection against accidental database deletion or deletion by an unauthorized user. A Neptune DB cluster can't be deleted while deletion protection is enabled. You must first disable deletion protection before a delete request can succeed.

This rule is covered by the [neptune-cluster-deletion-protection-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/neptune/neptune-cluster-deletion-protection-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # neptune-cluster-deletion-protection-enabled.policytest.hcl... running
      # resource.aws_neptune_cluster.pass_deletion_protection_enabled... running
      # resource.aws_neptune_cluster.pass_deletion_protection_enabled... pass
      # resource.aws_neptune_cluster.fail_deletion_protection_disabled... running
      # resource.aws_neptune_cluster.fail_deletion_protection_disabled... pass
      # resource.aws_neptune_cluster.fail_missing_deletion_protection... running
      # resource.aws_neptune_cluster.fail_missing_deletion_protection... pass
      # neptune-cluster-deletion-protection-enabled.policytest.hcl... pass
```

---
