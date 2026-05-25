# FSx for OpenZFS file systems should be configured to copy tags to backups and volumes

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Tagging |

## Description

This control checks whether an Amazon FSx for OpenZFS file system is configured to copy tags to backups and volumes. The control fails if the OpenZFS file system isn't configured to copy tags to backups and volumes.

Identification and inventory of your IT assets is an important aspect of governance and security. Tags help you categorize your AWS resources in different ways, for example, by purpose, owner, or environment. This is useful when you have many resources of the same type because you can quickly identify a specific resource based on the tags that you assigned to it.

This rule is covered by the [fsx-openzfs-copy-tags-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/fsx/fsx-openzfs-copy-tags-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # fsx-openzfs-copy-tags-enabled.policytest.hcl... running
      # resource.aws_fsx_openzfs_file_system.pass_copy_tags_enabled... running
      # resource.aws_fsx_openzfs_file_system.pass_copy_tags_enabled... pass
      # resource.aws_fsx_openzfs_file_system.fail_copy_tags_backup_disabled... running
      # resource.aws_fsx_openzfs_file_system.fail_copy_tags_backup_disabled... pass
      # resource.aws_fsx_openzfs_file_system.fail_copy_tags_volume_disabled... running
      # resource.aws_fsx_openzfs_file_system.fail_copy_tags_volume_disabled... pass
      # resource.aws_fsx_openzfs_file_system.fail_copy_tags_disabled... running
      # resource.aws_fsx_openzfs_file_system.fail_copy_tags_disabled... pass
      # resource.aws_fsx_openzfs_file_system.fail_copy_tags_backup_missing... running
      # resource.aws_fsx_openzfs_file_system.fail_copy_tags_backup_missing... pass
      # resource.aws_fsx_openzfs_file_system.fail_copy_tags_missing... running
      # resource.aws_fsx_openzfs_file_system.fail_copy_tags_missing... pass
      # fsx-openzfs-copy-tags-enabled.policytest.hcl... pass
```

---
