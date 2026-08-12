# Neptune DB clusters should be encrypted at rest

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks whether a Neptune DB cluster is encrypted at rest. The control fails if a Neptune DB cluster isn't encrypted at rest.

Data at rest refers to any data that's stored in persistent, non-volatile storage for any duration. Encryption helps you protect the confidentiality of such data, reducing the risk that an unauthorized user can access it. Encrypting your Neptune DB clusters protects your data and metadata against unauthorized access. It also fulfills compliance requirements for data-at-rest encryption of production file systems.

This rule is covered by the [neptune-cluster-encrypted](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/neptune/neptune-cluster-encrypted.policy.hcl) policy.

## Policy Results

```bash
trace:
      # neptune-cluster-encrypted.policytest.hcl... running
      # resource.aws_neptune_cluster.pass_encrypted_no_input_no_key... running
      # resource.aws_neptune_cluster.pass_encrypted_no_input_no_key... pass
      # resource.aws_neptune_cluster.pass_encrypted_no_input_with_key... running
      # resource.aws_neptune_cluster.pass_encrypted_no_input_with_key... pass
      # resource.aws_neptune_cluster.fail_encryption_disabled... running
      # resource.aws_neptune_cluster.fail_encryption_disabled... pass
      # resource.aws_neptune_cluster.fail_missing_storage_encrypted... running
      # resource.aws_neptune_cluster.fail_missing_storage_encrypted... pass
      # neptune-cluster-encrypted.policytest.hcl... pass
```

---
