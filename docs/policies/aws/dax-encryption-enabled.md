# DynamoDB Accelerator (DAX) clusters should be encrypted at rest

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks whether an Amazon DynamoDB Accelerator (DAX) cluster is encrypted at rest. The control fails if the DAX cluster isn't encrypted at rest.

Encrypting data at rest reduces the risk of data stored on disk being accessed by a user not authenticated to AWS. The encryption adds another set of access controls to limit the ability of unauthorized users to access to the data. For example, API permissions are required to decrypt the data before it can be read.

This rule is covered by the [dax-encryption-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/dax/dax-encryption-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # dax-encryption-enabled.policytest.hcl...
      running
      # resource.aws_dax_cluster.pass_encryption_enabled...
      running
      # resource.aws_dax_cluster.pass_encryption_enabled...
      pass
      # resource.aws_dax_cluster.fail_encryption_disabled...
      running
      # resource.aws_dax_cluster.fail_encryption_disabled...
      pass
      # resource.aws_dax_cluster.fail_no_encryption_block...
      running
      # resource.aws_dax_cluster.fail_no_encryption_block...
      pass
      # resource.aws_dax_cluster.fail_encryption_not_specified...
      running
      # resource.aws_dax_cluster.fail_encryption_not_specified...
      pass
      # dax-encryption-enabled.policytest.hcl...
      pass
```

---
