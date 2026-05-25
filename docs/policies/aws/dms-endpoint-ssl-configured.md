# DMS endpoints should use SSL

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks whether an AWS DMS endpoint uses an SSL connection. The control fails if the endpoint doesn't use SSL.

SSL/TLS connections provide a layer of security by encrypting connections between DMS replication instances and your database. Using certificates provides an extra layer of security by validating that the connection is being made to the expected database. It does so by checking the server certificate that is automatically installed on all database instances that you provision. By enabling SSL connection on your DMS endpoints, you protect the confidentiality of the data during the migration.

This rule is covered by the [dms-endpoint-ssl-configured](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/dms/dms-endpoint-ssl-configured.policy.hcl) policy.

## Policy Results

```bash
trace:
      # dms-endpoint-ssl-configured.policytest.hcl...
      running
      # resource.aws_dms_endpoint.pass_ssl_mode_require...
      running
      # resource.aws_dms_endpoint.pass_ssl_mode_require...
      pass
      # resource.aws_dms_endpoint.pass_ssl_mode_verify_ca...
      running
      # resource.aws_dms_endpoint.pass_ssl_mode_verify_ca...
      pass
      # resource.aws_dms_endpoint.pass_ssl_mode_verify_full...
      running
      # resource.aws_dms_endpoint.pass_ssl_mode_verify_full...
      pass
      # resource.aws_dms_endpoint.fail_ssl_mode_none...
      running
      # resource.aws_dms_endpoint.fail_ssl_mode_none...
      pass
      # resource.aws_dms_endpoint.fail_ssl_mode_not_configured...
      running
      # resource.aws_dms_endpoint.fail_ssl_mode_not_configured...
      pass
      # dms-endpoint-ssl-configured.policytest.hcl...
      pass
```

---
