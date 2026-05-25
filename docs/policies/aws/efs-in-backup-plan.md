# Amazon EFS volumes should be in backup plans

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Backup |

## Description

This control checks whether Amazon Elastic File System (Amazon EFS) file systems are added to the backup plans in AWS Backup. The control fails if Amazon EFS file systems are not included in the backup plans.

Including EFS file systems in the backup plans helps you to protect your data from deletion and data loss.

This rule is covered by the [efs-in-backup-plan](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/efs/efs-in-backup-plan.policy.hcl) policy.

## Policy Results

```bash
trace:
      # efs-in-backup-plan.policytest.hcl... running
      # resource.aws_efs_file_system.protected... running
      # resource.aws_efs_file_system.protected... pass
      # resource.aws_efs_file_system.tagged... running
      # resource.aws_efs_file_system.tagged... pass
      # resource.aws_efs_file_system.unprotected... running
      # resource.aws_efs_file_system.unprotected... pass
      # resource.aws_efs_file_system.with_backup_policy... running
      # resource.aws_efs_file_system.with_backup_policy... pass
      # resource.aws_efs_file_system.with_disabled_backup_policy... running
      # resource.aws_efs_file_system.with_disabled_backup_policy... pass
      # efs-in-backup-plan.policytest.hcl... pass
```

---
