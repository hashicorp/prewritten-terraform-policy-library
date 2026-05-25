# Elasticsearch domains should have audit logging enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This rule is NON_COMPLIANT if the CloudWatch Logs log group of the Elasticsearch domain is not specified in this parameter list.

This control checks whether Elasticsearch domains have audit logging enabled. This control fails if an Elasticsearch domain does not have audit logging enabled.

Audit logs are highly customizable. They allow you to track user activity on your Elasticsearch clusters, including authentication successes and failures, requests to OpenSearch, index changes, and incoming search queries.

This rule is covered by the [elasticsearch-audit-logging-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/elasticsearch/elasticsearch-audit-logging-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # elasticsearch-audit-logging-enabled.policytest.hcl... running
      # resource.aws_elasticsearch_domain.pass_fully_configured... running
      # resource.aws_elasticsearch_domain.pass_fully_configured... pass
      # resource.aws_elasticsearch_domain.pass_enabled_default... running
      # resource.aws_elasticsearch_domain.pass_enabled_default... pass
      # resource.aws_elasticsearch_domain.pass_multiple_log_types... running
      # resource.aws_elasticsearch_domain.pass_multiple_log_types... pass
      # resource.aws_elasticsearch_domain.fail_no_audit_logs... running
      # resource.aws_elasticsearch_domain.fail_no_audit_logs... pass
      # resource.aws_elasticsearch_domain.fail_audit_disabled... running
      # resource.aws_elasticsearch_domain.fail_audit_disabled... pass
      # resource.aws_elasticsearch_domain.fail_no_log_group_arn... running
      # resource.aws_elasticsearch_domain.fail_no_log_group_arn... pass
      # resource.aws_elasticsearch_domain.fail_empty_log_group_arn... running
      # resource.aws_elasticsearch_domain.fail_empty_log_group_arn... pass
      # elasticsearch-audit-logging-enabled.policytest.hcl... pass
```

---
