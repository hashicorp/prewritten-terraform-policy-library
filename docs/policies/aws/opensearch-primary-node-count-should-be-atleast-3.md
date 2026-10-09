# OpenSearch domains should have at least three dedicated primary nodes

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | High availability |

## Description

This control checks whether an Amazon OpenSearch Service domain is configured with at least three dedicated primary nodes. The control fails if the domain has fewer than three dedicated primary nodes.

OpenSearch Service uses dedicated primary nodes to increase cluster stability. A dedicated primary node performs cluster management tasks, but doesn't hold data or respond to data upload requests. We recommend that you use multi-AZ with standby, which adds three dedicated primary nodes to each production OpenSearch domain.

This rule is covered by the [opensearch-primary-node-count-should-be-atleast-3](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/opensearch/opensearch-primary-node-count-should-be-atleast-3.policy.hcl) policy.

## Policy Results

```bash
trace:
      ## opensearch-primary-node-count-should-be-atleast-3.policytest.hcl... running
      # resource.aws_opensearch_domain.pass_enabled_count_3... running
      # resource.aws_opensearch_domain.pass_enabled_count_3... pass
      # resource.aws_opensearch_domain.pass_enabled_count_5... running
      # resource.aws_opensearch_domain.pass_enabled_count_5... pass
      # resource.aws_opensearch_domain.pass_no_cluster_config... running
      # resource.aws_opensearch_domain.pass_no_cluster_config... pass
      # resource.aws_opensearch_domain.pass_empty_cluster_config... running
      # resource.aws_opensearch_domain.pass_empty_cluster_config... pass
      # resource.aws_opensearch_domain.pass_null_count... running
      # resource.aws_opensearch_domain.pass_null_count... pass
      # resource.aws_opensearch_domain.pass_null_enabled... running
      # resource.aws_opensearch_domain.pass_null_enabled... pass
      # resource.aws_opensearch_domain.fail_enabled_count_2... running
      # resource.aws_opensearch_domain.fail_enabled_count_2... pass
      # resource.aws_opensearch_domain.fail_enabled_count_1... running
      # resource.aws_opensearch_domain.fail_enabled_count_1... pass
      # resource.aws_opensearch_domain.fail_disabled_count_3... running
      # resource.aws_opensearch_domain.fail_disabled_count_3... pass
      # resource.aws_opensearch_domain.fail_disabled_count_1... running
      # resource.aws_opensearch_domain.fail_disabled_count_1... pass
      # opensearch-primary-node-count-should-be-atleast-3.policytest.hcl... pass
```

---