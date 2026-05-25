# Elasticsearch domain error logging to CloudWatch Logs should be enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Identify - Logging |

## Description

This control checks whether Elasticsearch domains are configured to send error logs to CloudWatch Logs.

You should enable error logs for Elasticsearch domains and send those logs to CloudWatch Logs for retention and response. Domain error logs can assist with security and access audits, and can help to diagnose availability issues.

This rule is covered by the [elasticsearch-logs-to-cloudwatch](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/elasticsearch/elasticsearch-logs-to-cloudwatch.policy.hcl) policy.

## Policy Results

```bash
trace:
      # elasticsearch-logs-to-cloudwatch.policytest.hcl... running
      # resource.aws_elasticsearch_domain.pass_with_default_enabled... running
      # resource.aws_elasticsearch_domain.pass_with_default_enabled... pass
      # resource.aws_elasticsearch_domain.pass_with_explicit_enabled_true... running
      # resource.aws_elasticsearch_domain.pass_with_explicit_enabled_true... pass
      # resource.aws_elasticsearch_domain.pass_with_multiple_log_types... running
      # resource.aws_elasticsearch_domain.pass_with_multiple_log_types... pass
      # resource.aws_elasticsearch_domain.skip_no_log_publishing_options... running
      # resource.aws_elasticsearch_domain.skip_no_log_publishing_options... pass
      # resource.aws_elasticsearch_domain.fail_missing_es_application_logs... running
      # resource.aws_elasticsearch_domain.fail_missing_es_application_logs... pass
      # resource.aws_elasticsearch_domain.fail_disabled_logging... running
      # resource.aws_elasticsearch_domain.fail_disabled_logging... pass
      # resource.aws_elasticsearch_domain.fail_missing_log_group_arn... running
      # resource.aws_elasticsearch_domain.fail_missing_log_group_arn... pass
      # resource.aws_elasticsearch_domain.fail_empty_log_group_arn... running
      # resource.aws_elasticsearch_domain.fail_empty_log_group_arn... pass
      # elasticsearch-logs-to-cloudwatch.policytest.hcl... pass
```

---
