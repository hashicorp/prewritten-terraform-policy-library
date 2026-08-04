# Elasticsearch domains should be configured with at least three dedicated master nodes

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | High availability |

## Description

This control checks whether Elasticsearch domains are configured with at least three dedicated primary nodes. This control fails if the domain does not use dedicated primary nodes. This control passes if Elasticsearch domains have five dedicated primary nodes. However, using more than three primary nodes might be unnecessary to mitigate the availability risk, and will result in additional cost.

An Elasticsearch domain requires at least three dedicated primary nodes for high availability and fault-tolerance. Dedicated primary node resources can be strained during data node blue/green deployments because there are additional nodes to manage. Deploying an Elasticsearch domain with at least three dedicated primary nodes ensures sufficient primary node resource capacity and cluster operations if a node fails.

This rule is covered by the [elasticsearch-primary-node-fault-tolerance](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/elasticsearch/elasticsearch-primary-node-fault-tolerance.policy.hcl) policy.

## Policy Results

```bash
trace:
      # elasticsearch-primary-node-fault-tolerance.policytest.hcl... running
      # resource.aws_elasticsearch_domain.elasticsearch_pass_three_masters... running
      # resource.aws_elasticsearch_domain.elasticsearch_pass_three_masters... pass
      # resource.aws_elasticsearch_domain.elasticsearch_pass_five_masters... running
      # resource.aws_elasticsearch_domain.elasticsearch_pass_five_masters... pass
      # resource.aws_elasticsearch_domain.elasticsearch_fail_disabled... running
      # resource.aws_elasticsearch_domain.elasticsearch_fail_disabled... pass
      # resource.aws_elasticsearch_domain.elasticsearch_fail_insufficient_count... running
      # resource.aws_elasticsearch_domain.elasticsearch_fail_insufficient_count... pass
      # resource.aws_elasticsearch_domain.elasticsearch_fail_no_count... running
      # resource.aws_elasticsearch_domain.elasticsearch_fail_no_count... pass
      # elasticsearch-primary-node-fault-tolerance.policytest.hcl... pass
```

---
