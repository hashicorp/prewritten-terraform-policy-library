# Elasticsearch domains should have at least three data nodes

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | High availability |

## Description

This control checks whether Elasticsearch domains are configured with at least three data nodes and zoneAwarenessEnabled is true.

An Elasticsearch domain requires at least three data nodes for high availability and fault-tolerance. Deploying an Elasticsearch domain with at least three data nodes ensures cluster operations if a node fails.

This rule is covered by the [elasticsearch-data-node-fault-tolerance](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/elasticsearch/elasticsearch-data-node-fault-tolerance.policy.hcl) policy.

## Policy Results

```bash
trace:
      # elasticsearch-data-node-fault-tolerance.policytest.hcl... running
      # resource.aws_elasticsearch_domain.pass_3_nodes_zone_aware... running
      # resource.aws_elasticsearch_domain.pass_3_nodes_zone_aware... pass
      # resource.aws_elasticsearch_domain.pass_6_nodes_zone_aware... running
      # resource.aws_elasticsearch_domain.pass_6_nodes_zone_aware... pass
      # resource.aws_elasticsearch_domain.fail_1_node... running
      # resource.aws_elasticsearch_domain.fail_1_node... pass
      # resource.aws_elasticsearch_domain.fail_2_nodes... running
      # resource.aws_elasticsearch_domain.fail_2_nodes... pass
      # resource.aws_elasticsearch_domain.fail_zone_awareness_disabled... running
      # resource.aws_elasticsearch_domain.fail_zone_awareness_disabled... pass
      # resource.aws_elasticsearch_domain.fail_zone_awareness_missing... running
      # resource.aws_elasticsearch_domain.fail_zone_awareness_missing... pass
      # elasticsearch-data-node-fault-tolerance.policytest.hcl... pass
```

---
