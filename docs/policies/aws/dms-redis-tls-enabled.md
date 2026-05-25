# DMS endpoints for Redis OSS should have TLS enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks whether an AWS DMS endpoint for Redis OSS is configured with a TLS connection. The control fails if the endpoint doesn't have TLS enabled.

TLS provides end-to-end security when data is sent between applications or databases over the internet. When you configure SSL encryption for your DMS endpoint, it enables encrypted communication between the source and target databases during the migration process. This helps prevent eavesdropping and interception of sensitive data by malicious actors. Without SSL encryption, sensitive data may be accessed, resulting in data breaches, data loss, or other security incidents.

This rule is covered by the [dms-redis-tls-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/dms/dms-redis-tls-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # dms-redis-tls-enabled.policytest.hcl...
      running
      # resource.aws_dms_endpoint.redis_explicit...
      running
      # resource.aws_dms_endpoint.redis_explicit...
      pass
      # resource.aws_dms_endpoint.redis_default...
      running
      # resource.aws_dms_endpoint.redis_default...
      pass
      # resource.aws_dms_endpoint.redis_plaintext...
      running
      # resource.aws_dms_endpoint.redis_plaintext...
      pass
      # resource.aws_dms_endpoint.mysql...
      running
      # resource.aws_dms_endpoint.mysql...
      pass
      # dms-redis-tls-enabled.policytest.hcl...
      pass
```

---
