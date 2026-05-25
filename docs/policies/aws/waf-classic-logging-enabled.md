# AWS WAF Classic Global Web ACL logging should be enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether logging is enabled for an AWS WAF global web ACL. This control fails if logging is not enabled for the web ACL.

Logging is an important part of maintaining the reliability, availability, and performance of AWS WAF globally. It is a business and compliance requirement in many organizations, and allows you to troubleshoot application behavior. It also provides detailed information about the traffic that is analyzed by the web ACL that is attached to AWS WAF.

This rule is covered by the [waf-classic-logging-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/waf/waf-classic-logging-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # waf-classic-logging-enabled.policytest.hcl... running
      # resource.aws_waf_web_acl.pass_with_valid_logging_and_firehose... running
      # resource.aws_waf_web_acl.pass_with_valid_logging_and_firehose... pass
      # resource.aws_kinesis_firehose_delivery_stream.pass_valid_stream... running
      # resource.aws_kinesis_firehose_delivery_stream.pass_valid_stream... pass
      # resource.aws_waf_web_acl.fail_without_logging_configuration... running
      # resource.aws_waf_web_acl.fail_without_logging_configuration... pass
      # resource.aws_waf_web_acl.fail_with_empty_log_destination... running
      # resource.aws_waf_web_acl.fail_with_empty_log_destination... pass
      # waf-classic-logging-enabled.policytest.hcl... pass
```

---
