# EFS file systems should be encrypted at rest

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks whether an Amazon EFS file system encrypts data with AWS Key Management Service (AWS KMS). The control fails if a file system isn't encrypted.

Data at rest refers to data that's stored in persistent, non-volatile storage for any duration. Encrypting data at rest helps you protect its confidentiality, which reduces the risk that an unauthorized user can access it.

This rule is covered by the [efs-filesystem-ct-encrypted](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/efs/efs-filesystem-ct-encrypted.policy.hcl) policy.

## Policy Results

```bash
trace:
      # efs-filesystem-ct-encrypted.policytest.hcl... running
      # resource.aws_efs_file_system.encrypted... running
      # resource.aws_efs_file_system.encrypted... pass
      # resource.aws_efs_file_system.encrypted_kms... running
      # resource.aws_efs_file_system.encrypted_kms... pass
      # resource.aws_efs_file_system.not_encrypted... running
      # resource.aws_efs_file_system.not_encrypted... pass
      # resource.aws_efs_file_system.no_encryption_attr... running
      # resource.aws_efs_file_system.no_encryption_attr... pass
      # efs-filesystem-ct-encrypted.policytest.hcl... pass
```

---
