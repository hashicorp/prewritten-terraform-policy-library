# OpenSearch domains should have the latest software update installed

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Vulnerability, patch, and version management |

## Description

This control checks whether an Amazon OpenSearch Service domain has the latest software update installed. The control fails if a software update is available but not installed for the domain.

OpenSearch Service software updates provide the latest platform fixes, updates, and features available for the environment. Keeping up-to-date with patch installation helps maintain domain security and availability. If no action is taken on required updates, the service software is updated automatically (typically after 2 weeks). We recommend scheduling updates during a time of low traffic to the domain to minimize service disruption.

This rule is covered by the [opensearch-update-check](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/opensearch/opensearch-update-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # opensearch-update-check.policytest.hcl... running
      # resource.aws_opensearch_domain.auto_updates_enabled... running
      # resource.aws_opensearch_domain.auto_updates_enabled... pass
      # resource.aws_opensearch_domain.auto_updates_disabled... running
      # resource.aws_opensearch_domain.auto_updates_disabled... pass
      # resource.aws_opensearch_domain.auto_updates_disabled... running
      # resource.aws_opensearch_domain.auto_updates_disabled... pass
      # resource.aws_opensearch_domain.auto_updates_not_configured... running
      # resource.aws_opensearch_domain.auto_updates_not_configured... pass
      # opensearch-update-check.policytest.hcl... pass
```

---
