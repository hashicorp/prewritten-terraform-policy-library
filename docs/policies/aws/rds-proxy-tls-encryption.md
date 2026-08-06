# RDS DB proxies should require TLS encryption for connections

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks whether an Amazon RDS DB proxy requires TLS for all connections between the proxy and the underlying RDS DB instance. The control fails if the proxy doesn't require TLS for all connections between the proxy and the RDS DB instance.

Amazon RDS Proxy can act as an additional layer of security between client applications and underlying RDS DB instances. For example, you can connect to an RDS proxy using TLS 1.3, even if the underlying DB instance supports an older version of TLS. By using RDS Proxy, you can enforce strong authentication requirements for database applications.

This rule is covered by the [rds-proxy-tls-encryption](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/rds/rds-proxy-tls-encryption.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-proxy-tls-encryption.policytest.hcl... running
      # resource.aws_db_proxy.tls_required... running
      # resource.aws_db_proxy.tls_required... pass
      # resource.aws_db_proxy.tls_not_required... running
      # resource.aws_db_proxy.tls_not_required... pass
      # resource.aws_db_proxy.tls_missing... running
      # resource.aws_db_proxy.tls_missing... pass
      # rds-proxy-tls-encryption.policytest.hcl... pass
```

---
