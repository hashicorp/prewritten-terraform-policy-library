# Elasticsearch domains should encrypt data sent between nodes

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks whether an Elasticsearch domain has node-to-node encryption enabled. The control fails if the Elasticsearch domain doesn't have node-to-node encryption enabled. The control also produces failed findings if an Elasticsearch version doesn't support node-to-node encryption checks.

HTTPS (TLS) can be used to help prevent potential attackers from eavesdropping on or manipulating network traffic using person-in-the-middle or similar attacks. Only encrypted connections over HTTPS (TLS) should be allowed. Enabling node-to-node encryption for Elasticsearch domains ensures that intra-cluster communications are encrypted in transit.

There can be a performance penalty associated with this configuration. You should be aware of and test the performance trade-off before enabling this option.

This rule is covered by the [elasticsearch-node-to-node-encryption-check](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/elasticsearch/elasticsearch-node-to-node-encryption-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # elasticsearch-node-to-node-encryption-check.policytest.hcl... running
      # resource.aws_elasticsearch_domain.pass_node_encryption... running
      # resource.aws_elasticsearch_domain.pass_node_encryption... pass
      # resource.aws_elasticsearch_domain.fail_unsupported_version... running
      # resource.aws_elasticsearch_domain.fail_unsupported_version... pass
      # resource.aws_elasticsearch_domain.fail_missing_version... running
      # resource.aws_elasticsearch_domain.fail_missing_version... pass
      # resource.aws_elasticsearch_domain.fail_node_encryption... running
      # resource.aws_elasticsearch_domain.fail_node_encryption... pass
      # resource.aws_elasticsearch_domain.missing_node_encryption... running
      # resource.aws_elasticsearch_domain.missing_node_encryption... pass
      # elasticsearch-node-to-node-encryption-check.policytest.hcl... pass
```

---
