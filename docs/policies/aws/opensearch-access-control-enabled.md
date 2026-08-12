# OpenSearch domains should have fine-grained access control enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Sensitive API actions restricted |

## Description

This control checks whether OpenSearch domains have fine-grained access control enabled. The control fails if the fine-grained access control is not enabled. Fine-grained access control requires advanced-security-optionsin the OpenSearch parameter update-domain-config to be enabled.

Fine-grained access control offers additional ways of controlling access to your data on Amazon OpenSearch Service.

This rule is covered by the [opensearch-access-control-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/opensearch/opensearch-access-control-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # opensearch-access-control-enabled.policytest.hcl... running
      # resource.aws_opensearch_domain.pass_fgac_enabled... running
      # resource.aws_opensearch_domain.pass_fgac_enabled... pass
      # resource.aws_opensearch_domain.fail_fgac_disabled... running
      # resource.aws_opensearch_domain.fail_fgac_disabled... pass
      # resource.aws_opensearch_domain.fail_no_advanced_security_options... running
      # resource.aws_opensearch_domain.fail_no_advanced_security_options... pass
      # resource.aws_opensearch_domain.fail_enabled_not_set... running
      # resource.aws_opensearch_domain.fail_enabled_not_set... pass
      # resource.aws_opensearch_domain.pass_fgac_with_additional_security... running
      # resource.aws_opensearch_domain.pass_fgac_with_additional_security... pass
      # opensearch-access-control-enabled.policytest.hcl... pass
```

---
