# Neptune DB cluster snapshots should be encrypted at rest

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks whether a Neptune DB cluster snapshot is encrypted at rest. The control fails if a Neptune DB cluster isn't encrypted at rest.

Data at rest refers to any data that's stored in persistent, non-volatile storage for any duration. Encryption helps you protect the confidentiality of such data, reducing the risk that an unauthorized user gets access to it. Data in Neptune DB clusters snapshots should be encrypted at rest for an added layer of security.

This rule is covered by the [neptune-cluster-snapshot-encrypted](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/neptune/neptune-cluster-snapshot-encrypted.policy.hcl) policy.

## Policy Results

```bash
trace:
      # neptune-cluster-snapshot-encrypted.policytest.hcl... running
      # resource.aws_neptune_cluster_snapshot.pass_snapshot_encrypted... running
      # resource.aws_neptune_cluster_snapshot.pass_snapshot_encrypted... pass
      # resource.aws_neptune_cluster_snapshot.fail_snapshot_not_encrypted... running
      # resource.aws_neptune_cluster_snapshot.fail_snapshot_not_encrypted... pass
      # resource.aws_neptune_cluster_snapshot.fail_snapshot_missing_encryption... running
      # resource.aws_neptune_cluster_snapshot.fail_snapshot_missing_encryption... pass
      # neptune-cluster-snapshot-encrypted.policytest.hcl... pass
```

---
