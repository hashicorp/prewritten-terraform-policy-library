# EFS file systems should have automatic backups enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Backups enabled |

## Description

This control checks whether an Amazon EFS file system has automatic backups enabled. This control fails if the EFS file system doesn't have automatic backups enabled.

A data backup is a copy of your system, configuration, or application data that's stored separately from the original. Enabling regular backups helps you safeguard valuable data against unforeseen events like system failures, cyberattacks, or accidental deletions. Having a robust backup strategy also facilitates quicker recovery, business continuity, and peace of mind in the face of potential data loss.

This rule is covered by the [efs-automatic-backups-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/efs/efs-automatic-backups-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # efs-automatic-backups-enabled.policytest.hcl... running
      # resource.aws_efs_backup_policy.pass_backup_enabled... running
      # resource.aws_efs_backup_policy.pass_backup_enabled... pass
      # resource.aws_efs_backup_policy.fail_backup_disabled... running
      # resource.aws_efs_backup_policy.fail_backup_disabled... pass
      # resource.aws_efs_backup_policy.fail_empty_backup_policy... running
      # resource.aws_efs_backup_policy.fail_empty_backup_policy... pass
      # resource.aws_efs_backup_policy.fail_missing_status... running
      # resource.aws_efs_backup_policy.fail_missing_status... pass
      # efs-automatic-backups-enabled.policytest.hcl... pass
```

---
