# Elastic File System should be configured to encrypt file data at-rest using AWS KMS

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks whether Amazon Elastic File System is configured to encrypt the file data using AWS KMS. The check fails in the following cases.

Encrypted is set to false in the DescribeFileSystems response.

Encrypted is set to false in the DescribeFileSystems response.

The KmsKeyId key in the DescribeFileSystems response does not match the KmsKeyId parameter for efs-encrypted-check.

The KmsKeyId key in the DescribeFileSystems response does not match the KmsKeyId parameter for efs-encrypted-check.

Note that this control does not use the KmsKeyId parameter for efs-encrypted-check. It only checks the value of Encrypted.

For an added layer of security for your sensitive data in Amazon EFS, you should create encrypted file systems. Amazon EFS supports encryption for file systems at-rest. You can enable encryption of data at rest when you create an Amazon EFS file system. To learn more about Amazon EFS encryption, see Data encryption in Amazon EFS in the Amazon Elastic File System User Guide.

This rule is covered by the [efs-encrypted-check](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/efs/efs-encrypted-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # efs-encrypted-check.policytest.hcl...
      running
      # resource.aws_efs_file_system.pass_encrypted_true...
      running
      # resource.aws_efs_file_system.pass_encrypted_true...
      pass
      # resource.aws_efs_file_system.fail_encrypted_false...
      running
      # resource.aws_efs_file_system.fail_encrypted_false...
      pass
      # resource.aws_efs_file_system.fail_encrypted_missing...
      running
      # resource.aws_efs_file_system.fail_encrypted_missing...
      pass
      # efs-encrypted-check.policytest.hcl...
      pass
```

---
