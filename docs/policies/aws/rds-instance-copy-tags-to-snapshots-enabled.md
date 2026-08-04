# RDS DB instances should be configured to copy tags to snapshots

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Inventory |

## Description

This control checks whether RDS DB instances are configured to copy all tags to snapshots when the snapshots are created.

Identification and inventory of your IT assets is a crucial aspect of governance and security. You need to have visibility of all your RDS DB instances so that you can assess their security posture and take action on potential areas of weakness. Snapshots should be tagged in the same way as their parent RDS database instances. Enabling this setting ensures that snapshots inherit the tags of their parent database instances.

This rule is covered by the [rds-instance-copy-tags-to-snapshots-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/rds/rds-instance-copy-tags-to-snapshots-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-instance-copy-tags-to-snapshots-enabled.policytest.hcl... running
      # resource.aws_db_instance.pass_copy_tags_to_snapshot... running
      # resource.aws_db_instance.pass_copy_tags_to_snapshot... pass
      # resource.aws_db_instance.fail_copy_tags_to_sanpshot... running
      # resource.aws_db_instance.fail_copy_tags_to_sanpshot... pass
      # resource.aws_db_instance.fail_missing_copy_tags_to_snapshot... running
      # resource.aws_db_instance.fail_missing_copy_tags_to_snapshot... pass
      # rds-instance-copy-tags-to-snapshots-enabled.policytest.hcl... pass
```

---
