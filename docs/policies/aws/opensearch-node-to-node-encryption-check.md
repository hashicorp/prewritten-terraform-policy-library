# OpenSearch domains should encrypt data sent between nodes

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks whether OpenSearch domains have node-to-node encryption enabled. This control fails if node-to-node encryption is disabled on the domain.

HTTPS (TLS) can be used to help prevent potential attackers from eavesdropping on or manipulating network traffic using person-in-the-middle or similar attacks. Only encrypted connections over HTTPS (TLS) should be allowed. Enabling node-to-node encryption for OpenSearch domains ensures that intra-cluster communications are encrypted in transit.

There can be a performance penalty associated with this configuration. You should be aware of and test the performance trade-off before enabling this option.

This rule is covered by the [opensearch-node-to-node-encryption-check](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/opensearch/opensearch-node-to-node-encryption-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # opensearch-node-to-node-encryption-check.policytest.hcl... running
      # resource.aws_opensearch_domain.node_encryption_enabled... running
      # resource.aws_opensearch_domain.node_encryption_enabled... pass
      # resource.aws_opensearch_domain.node_encryption_disabled... running
      # resource.aws_opensearch_domain.node_encryption_disabled... pass
      # resource.aws_opensearch_domain.node_encryption_missing... running
      # resource.aws_opensearch_domain.node_encryption_missing... pass
      # resource.aws_opensearch_domain.node_encryption_invalid_version... running
      # resource.aws_opensearch_domain.node_encryption_invalid_version... pass
      # resource.aws_opensearch_domain.node_encryption_opensearch_disabled... running
      # resource.aws_opensearch_domain.node_encryption_opensearch_disabled... pass
      # resource.aws_opensearch_domain.node_encryption_opensearch_enabled... running
      # resource.aws_opensearch_domain.node_encryption_opensearch_enabled... pass
      # opensearch-node-to-node-encryption-check.policytest.hcl... pass
```

---
