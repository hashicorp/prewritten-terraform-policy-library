# Aurora DB clusters should be configured to copy tags to DB snapshots

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Inventory |

## Description

This control checks whether an Amazon Aurora DB cluster is configured to automatically copy tags to snapshots of the DB cluster when the snapshots are created. The control fails if the Aurora DB cluster isn't configured to automatically copy tags to snapshots of the cluster when the snapshots are created.

Identification and inventory of your IT assets is a crucial aspect of governance and security. You need to have visibility of all your Amazon Aurora DB clusters so that you can assess their security posture and take action on potential areas of weakness. Aurora DB snapshots should have the same tags as their parent DB clusters. In Amazon Aurora, you can configure a DB cluster to automatically copy all the tags for the cluster to snapshots of the cluster. Enabling this setting ensures that DB snapshots inherit the same tags as their parent DB clusters.

This rule is covered by the [rds-cluster-copy-tags-to-snapshots-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/rds/rds-cluster-copy-tags-to-snapshots-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-cluster-copy-tags-to-snapshots-enabled.policytest.hcl... running
      # resource.aws_rds_cluster.pass_copy_tags_to_snapshot... running
      # resource.aws_rds_cluster.pass_copy_tags_to_snapshot... pass
      # resource.aws_rds_cluster.fail_copy_tags_to_sanpshot... running
      # resource.aws_rds_cluster.fail_copy_tags_to_sanpshot... pass
      # resource.aws_rds_cluster.fail_missing_copy_tags_to_snapshot... running
      # resource.aws_rds_cluster.fail_missing_copy_tags_to_snapshot... pass
      # rds-cluster-copy-tags-to-snapshots-enabled.policytest.hcl... pass
```

---
