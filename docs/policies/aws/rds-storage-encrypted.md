# RDS DB instances should have encryption at-rest enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks whether storage encryption is enabled for your Amazon RDS DB instances.

This control is intended for RDS DB instances. However, it can also generate findings for Aurora DB instances, Neptune DB instances, and Amazon DocumentDB clusters. If these findings are not useful, then you can suppress them.

For an added layer of security for your sensitive data in RDS DB instances, you should configure your RDS DB instances to be encrypted at rest. To encrypt your RDS DB instances and snapshots at rest, enable the encryption option for your RDS DB instances. Data that is encrypted at rest includes the underlying storage for DB instances, its automated backups, read replicas, and snapshots.

RDS encrypted DB instances use the open standard AES-256 encryption algorithm to encrypt your data on the server that hosts your RDS DB instances. After your data is encrypted, Amazon RDS handles authentication of access and decryption of your data transparently with a minimal impact on performance. You do not need to modify your database client applications to use encryption.

Amazon RDS encryption is currently available for all database engines and storage types. Amazon RDS encryption is available for most DB instance classes. To learn about DB instance classes that do not support Amazon RDS encryption, see Encrypting Amazon RDS resources in the Amazon RDS User Guide.

This rule is covered by the [rds-storage-encrypted](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/rds/rds-storage-encrypted.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-storage-encrypted.policytest.hcl... running
      # resource.aws_db_instance.pass_storage_encrypted_true... running
      # resource.aws_db_instance.pass_storage_encrypted_true... pass
      # resource.aws_db_instance.fail_storage_encrypted_false... running
      # resource.aws_db_instance.fail_storage_encrypted_false... pass
      # resource.aws_db_instance.fail_storage_encrypted_missing... running
      # resource.aws_db_instance.fail_storage_encrypted_missing... pass
      # rds-storage-encrypted.policytest.hcl... pass
```

---
