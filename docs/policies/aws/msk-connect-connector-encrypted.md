# MSK Connect connectors should be encrypted in transit

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks whether an Amazon MSK Connect connector is encrypted in transit. This control fails if the connector isn't encrypted in transit.

Data in transit refers to data that moves from one location to another, such as between nodes in your cluster or between your cluster and your application. Data may move across the internet or within a private network. Encrypting data in transit reduces the risk that an unauthorized user can eavesdrop on network traffic.

This rule is covered by the [msk-connect-connector-encrypted](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/msk/msk-connect-connector-encrypted.policy.hcl) policy.

## Policy Results

```bash
trace:
      # msk-connect-connector-encrypted.policytest.hcl...
      running
      # resource.aws_mskconnect_connector.pass_tls_enabled...
      running
      # resource.aws_mskconnect_connector.pass_tls_enabled...
      pass
      # resource.aws_mskconnect_connector.fail_plaintext...
      running
      # resource.aws_mskconnect_connector.fail_plaintext...
      pass
      # resource.aws_mskconnect_connector.filtered_no_config...
      running
      # resource.aws_mskconnect_connector.filtered_no_config...
      pass
      # resource.aws_mskconnect_connector.fail_empty_config...
      running
      # resource.aws_mskconnect_connector.fail_empty_config...
      pass
      # msk-connect-connector-encrypted.policytest.hcl...
      pass
```

---