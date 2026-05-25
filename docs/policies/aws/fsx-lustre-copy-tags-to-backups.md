# FSx for Lustre file systems should be configured to copy tags to backups

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Tagging |

## Description

This control checks whether an Amazon FSx for Lustre file system is configured to copy tags to backups and volumes. The control fails if the Lustre file system isn't configured to copy tags to backups and volumes.

Identification and inventory of your IT assets is an important aspect of governance and security. Tags help you categorize your AWS resources in different ways, for example, by purpose, owner, or environment. This is useful when you have many resources of the same type because you can quickly identify a specific resource based on the tags that you assigned to it.

This rule is covered by the [fsx-lustre-copy-tags-to-backups](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/fsx/fsx-lustre-copy-tags-to-backups.policy.hcl) policy.

## Policy Results

```bash
trace:
      # fsx-lustre-copy-tags-to-backups.policytest.hcl... running
      # resource.aws_fsx_lustre_file_system.pass_copy_tags_enabled... running
      # resource.aws_fsx_lustre_file_system.pass_copy_tags_enabled... pass
      # resource.aws_fsx_lustre_file_system.fail_copy_tags_disabled... running
      # resource.aws_fsx_lustre_file_system.fail_copy_tags_disabled... pass
      # resource.aws_fsx_lustre_file_system.fail_wrong_deployment... running
      # resource.aws_fsx_lustre_file_system.fail_wrong_deployment... pass
      # resource.aws_fsx_lustre_file_system.pass_persistent_2... running
      # resource.aws_fsx_lustre_file_system.pass_persistent_2... pass
      # resource.aws_fsx_lustre_file_system.fail_persistent_2... running
      # resource.aws_fsx_lustre_file_system.fail_persistent_2... pass
      # fsx-lustre-copy-tags-to-backups.policytest.hcl... pass
```

---
