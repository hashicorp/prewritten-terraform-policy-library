# DynamoDB Accelerator clusters should be encrypted in transit

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks whether an Amazon DynamoDB Accelerator (DAX) cluster is encrypted in transit, with the endpoint encryption type set to TLS. The control fails if the DAX cluster isn't encrypted in transit.

HTTPS (TLS) can be used to help prevent potential attackers from using person-in-the-middle or similar attacks to eavesdrop on or manipulate network traffic. You should only allow encrypted connections over TLS to access DAX clusters. However, encrypting data in transit can affect performance. You should test your application with encryption turned on to understand the performance profile and the impact of TLS.

This rule is covered by the [dax-tls-endpoint-encryption](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/dynamo/dax-tls-endpoint-encryption.policy.hcl) policy.

## Policy Results

```bash
trace:
      # dax-tls-endpoint-encryption.policytest.hcl...
      running
      # resource.aws_dax_cluster.pass_tls_enabled...
      running
      # resource.aws_dax_cluster.pass_tls_enabled...
      pass
      # resource.aws_dax_cluster.fail_encryption_none...
      running
      # resource.aws_dax_cluster.fail_encryption_none...
      pass
      # resource.aws_dax_cluster.fail_encryption_missing...
      running
      # resource.aws_dax_cluster.fail_encryption_missing...
      pass
      # dax-tls-endpoint-encryption.policytest.hcl...
      pass
```

---
