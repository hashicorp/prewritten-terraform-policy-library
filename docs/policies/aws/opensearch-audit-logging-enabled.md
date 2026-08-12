# OpenSearch domains should have audit logging enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether OpenSearch domains have audit logging enabled. This control fails if an OpenSearch domain does not have audit logging enabled.

Audit logs are highly customizable. They allow you to track user activity on your OpenSearch clusters, including authentication successes and failures, requests to OpenSearch, index changes, and incoming search queries.

This rule is covered by the [opensearch-audit-logging-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/opensearch/opensearch-audit-logging-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # opensearch-audit-logging-enabled.policytest.hcl... running
      # resource.aws_opensearch_domain.pass_audit_logs_enabled... running
      # resource.aws_opensearch_domain.pass_audit_logs_enabled... pass
      # resource.aws_opensearch_domain.fail_audit_logs_disabled... running
      # resource.aws_opensearch_domain.fail_audit_logs_disabled... pass
      # resource.aws_opensearch_domain.skip_no_log_options... running
      # resource.aws_opensearch_domain.skip_no_log_options... pass
      # resource.aws_opensearch_domain.fail_no_audit_logs... running
      # resource.aws_opensearch_domain.fail_no_audit_logs... pass
      # resource.aws_opensearch_domain.pass_multiple_logs_with_audit... running
      # resource.aws_opensearch_domain.pass_multiple_logs_with_audit... pass
      # opensearch-audit-logging-enabled.policytest.hcl... pass
```

---
