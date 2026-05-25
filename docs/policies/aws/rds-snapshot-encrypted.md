# RDS cluster snapshots and database snapshots should be encrypted at rest

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks whether an RDS DB snapshot is encrypted. The control fails if an RDS DB snapshot isn't encrypted.

This control is intended for RDS DB instances. However, it can also generate findings for snapshots of Aurora DB instances, Neptune DB instances, and Amazon DocumentDB clusters. If these findings are not useful, then you can suppress them.

Encrypting data at rest reduces the risk that an unauthenticated user gets access to data that is stored on disk. Data in RDS snapshots should be encrypted at rest for an added layer of security.

This rule is covered by the [rds-snapshot-encrypted](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/rds/rds-snapshot-encrypted.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-snapshot-encrypted.policytest.hcl... running
      # resource.aws_db_snapshot.pass_encrypted... running
      # resource.aws_db_snapshot.pass_encrypted... pass
      # resource.aws_db_snapshot.fail_unencrypted... running
      # resource.aws_db_snapshot.fail_unencrypted... pass
      # resource.aws_db_snapshot.missing_unencrypted... running
      # resource.aws_db_snapshot.missing_unencrypted... pass
      # resource.aws_db_cluster_snapshot.pass_cluster_encrypted... running
      # resource.aws_db_cluster_snapshot.pass_cluster_encrypted... pass
      # resource.aws_db_cluster_snapshot.fail_cluster_unencrypted... running
      # resource.aws_db_cluster_snapshot.fail_cluster_unencrypted... pass
      # resource.aws_db_cluster_snapshot.missing_cluster_unencrypted... running
      # resource.aws_db_cluster_snapshot.missing_cluster_unencrypted... pass
      # rds-snapshot-encrypted.policytest.hcl... pass
```

---
