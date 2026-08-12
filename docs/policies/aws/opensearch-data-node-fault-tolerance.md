# OpenSearch domains should have at least three data nodes

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | High availability |

## Description

This control checks whether OpenSearch domains are configured with at least three data nodes and zoneAwarenessEnabled is true. This control fails for an OpenSearch domain if instanceCount is less than 3 or zoneAwarenessEnabled is false.

To achieve cluster-level high availability and fault tolerance, an OpenSearch domain should have at least three data nodes. Deploying an OpenSearch domain with at least three data nodes ensures cluster operations if a node fails.

This rule is covered by the [opensearch-data-node-fault-tolerance](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/opensearch/opensearch-data-node-fault-tolerance.policy.hcl) policy.

## Policy Results

```bash
trace:
      # opensearch-data-node-fault-tolerance.policytest.hcl... running
      # resource.aws_opensearch_domain.pass_minimum_nodes_with_zone_awareness... running
      # resource.aws_opensearch_domain.pass_minimum_nodes_with_zone_awareness... pass
      # resource.aws_opensearch_domain.pass_more_than_minimum_nodes... running
      # resource.aws_opensearch_domain.pass_more_than_minimum_nodes... pass
      # resource.aws_opensearch_domain.fail_insufficient_nodes_two... running
      # resource.aws_opensearch_domain.fail_insufficient_nodes_two... pass
      # resource.aws_opensearch_domain.fail_insufficient_nodes_one... running
      # resource.aws_opensearch_domain.fail_insufficient_nodes_one... pass
      # resource.aws_opensearch_domain.fail_zone_awareness_disabled... running
      # resource.aws_opensearch_domain.fail_zone_awareness_disabled... pass
      # resource.aws_opensearch_domain.fail_many_nodes_no_zone_awareness... running
      # resource.aws_opensearch_domain.fail_many_nodes_no_zone_awareness... pass
      # resource.aws_opensearch_domain.fail_both_conditions_not_met... running
      # resource.aws_opensearch_domain.fail_both_conditions_not_met... pass
      # resource.aws_opensearch_domain.fail_default_instance_count... running
      # resource.aws_opensearch_domain.fail_default_instance_count... pass
      # resource.aws_opensearch_domain.fail_default_zone_awareness... running
      # resource.aws_opensearch_domain.fail_default_zone_awareness... pass
      # opensearch-data-node-fault-tolerance.policytest.hcl... pass
```

---
