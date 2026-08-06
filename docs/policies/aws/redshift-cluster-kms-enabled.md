# Redshift clusters should be encrypted at rest

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks if Amazon Redshift clusters are encrypted at rest. The control fails if a Redshift cluster isn't encrypted at rest or if the encryption key is different from the provided key in the rule parameter.

In Amazon Redshift, you can turn on database encryption for your clusters to help protect data at rest. When you turn on encryption for a cluster, the data blocks and system metadata are encrypted for the cluster and its snapshots. Encryption of data at rest is a recommended best practice because it adds a layer of access management to your data. Encrypting Redshift clusters at rest reduces the risk that an unauthorized user can access the data stored on disk.

This rule is covered by the [redshift-cluster-kms-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/redshift/redshift-cluster-kms-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # redshift-cluster-kms-enabled.policytest.hcl... running
      # resource.aws_redshift_cluster.fail_encryption_disabled... running
      # resource.aws_redshift_cluster.fail_encryption_disabled... pass
      # resource.aws_redshift_cluster.fail_encrypted_no_kms_key... running
      # resource.aws_redshift_cluster.fail_encrypted_no_kms_key... pass
      # resource.aws_redshift_cluster.fail_encrypted_empty_kms... running
      # resource.aws_redshift_cluster.fail_encrypted_empty_kms... pass
      # redshift-cluster-kms-enabled.policytest.hcl... pass
```

---
