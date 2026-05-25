# Neptune DB clusters should be configured to copy tags to snapshots

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Tagging |

## Description

This control checks if a Neptune DB cluster is configured to copy all tags to snapshots when the snapshots are created. The control fails if a Neptune DB cluster isn't configured to copy tags to snapshots.

Identification and inventory of your IT assets is a crucial aspect of governance and security. You should tag snapshots in the same way as their parent Amazon RDS database clusters. Copying tags ensures that the metadata for the DB snapshots matches that of the parent database clusters, and that access policies for the DB snapshot also match those of the parent DB instance.

This rule is covered by the [neptune-cluster-copy-tags-to-snapshot-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/neptune/neptune-cluster-copy-tags-to-snapshot-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # neptune-cluster-copy-tags-to-snapshot-enabled.policytest.hcl... running
      # resource.aws_neptune_cluster.pass_copy_tags_enabled... running
      # resource.aws_neptune_cluster.pass_copy_tags_enabled... pass
      # resource.aws_neptune_cluster.fail_copy_tags_disabled... running
      # resource.aws_neptune_cluster.fail_copy_tags_disabled... pass
      # resource.aws_neptune_cluster.fail_copy_tags_missing... running
      # resource.aws_neptune_cluster.fail_copy_tags_missing... pass
      # neptune-cluster-copy-tags-to-snapshot-enabled.policytest.hcl... pass
```

---
