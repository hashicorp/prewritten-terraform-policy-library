# AWS Backup recovery points should be encrypted at rest

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks if an AWS Backup recovery point is encrypted at rest. The control fails if the recovery point isn't encrypted at rest.

An AWS Backup recovery point refers to a specific copy or snapshot of data that is created as part of a backup process. It represents a particular moment in time when the data was backed up and serves as a restore point in case the original data becomes lost, corrupted, or inaccessible. Encrypting the backup recovery points adds an extra layer of protection against unauthorized access. Encryption is a best practice to protect the confidentiality, integrity, and security of backup data.

This rule is covered by the [backup-recovery-point-encrypted](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/backup/backup-recovery-point-encrypted.policy.hcl) policy.

## Policy Results

```bash
trace:
      # backup-recovery-point-encrypted.policytest.hcl... running
      # resource.aws_backup_framework.pass_encrypted... running
      # resource.aws_backup_framework.pass_encrypted... pass
      # resource.aws_backup_framework.fail_encrypted... running
      # resource.aws_backup_framework.fail_encrypted... pass
      # resource.aws_backup_framework.fail_empty... running
      # resource.aws_backup_framework.fail_empty... pass
      # backup-recovery-point-encrypted.policytest.hcl... pass
```

---
