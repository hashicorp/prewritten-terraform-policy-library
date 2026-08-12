# Amazon DocumentDB clusters should be encrypted at rest

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks whether an Amazon DocumentDB cluster is encrypted at rest. The control fails if an Amazon DocumentDB cluster isn't encrypted at rest.

Data at rest refers to any data that's stored in persistent, non-volatile storage for any duration. Encryption helps you protect the confidentiality of such data, reducing the risk that an unauthorized user gets access to it. Data in Amazon DocumentDB clusters should be encrypted at rest for an added layer of security. Amazon DocumentDB uses the 256-bit Advanced Encryption Standard (AES-256) to encrypt your data using encryption keys stored in AWS Key Management Service (AWS KMS).

This rule is covered by the [docdb-cluster-encrypted](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/docdb/docdb-cluster-encrypted.policy.hcl) policy.

## Policy Results

```bash
trace:
      # docdb-cluster-encrypted.policytest.hcl... running
      # resource.aws_docdb_cluster.pass_encrypted_no_input_no_key... running
      # resource.aws_docdb_cluster.pass_encrypted_no_input_no_key... pass
      # resource.aws_docdb_cluster.pass_encrypted_no_input_with_key... running
      # resource.aws_docdb_cluster.pass_encrypted_no_input_with_key... pass
      # resource.aws_docdb_cluster.fail_encryption_disabled... running
      # resource.aws_docdb_cluster.fail_encryption_disabled... pass
      # resource.aws_docdb_cluster.fail_missing_storage_encrypted... running
      # resource.aws_docdb_cluster.fail_missing_storage_encrypted... pass
      # docdb-cluster-encrypted.policytest.hcl... pass
```

---
