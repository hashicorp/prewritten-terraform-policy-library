# RDS DB clusters should be encrypted at rest

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks if an RDS DB cluster is encrypted at rest. The control fails if an RDS DB cluster isn't encrypted at rest.

Data at rest refers to any data that's stored in persistent, non-volatile storage for any duration. Encryption helps you protect the confidentiality of such data, reducing the risk that an unauthorized user can access it. Encrypting your RDS DB clusters protects your data and metadata against unauthorized access. It also fulfills compliance requirements for data-at-rest encryption of production file systems.

This rule is covered by the [rds-cluster-encrypted-at-rest](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/rds/rds-cluster-encrypted-at-rest.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-cluster-encrypted-at-rest.policytest.hcl... running
      # resource.aws_rds_cluster.provisioned_encrypted_true... running
      # resource.aws_rds_cluster.provisioned_encrypted_true... pass
      # resource.aws_rds_cluster.provisioned_encrypted_false... running
      # resource.aws_rds_cluster.provisioned_encrypted_false... pass
      # resource.aws_rds_cluster.provisioned_no_encryption_attr... running
      # resource.aws_rds_cluster.provisioned_no_encryption_attr... pass
      # resource.aws_rds_cluster.serverless_encrypted_true... running
      # resource.aws_rds_cluster.serverless_encrypted_true... pass
      # resource.aws_rds_cluster.serverless_encrypted_false... running
      # resource.aws_rds_cluster.serverless_encrypted_false... pass
      # resource.aws_rds_cluster.serverless_no_encryption_attr... running
      # resource.aws_rds_cluster.serverless_no_encryption_attr... pass
      # rds-cluster-encrypted-at-rest.policytest.hcl... pass
```

---
