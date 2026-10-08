# AWS WAF web ACL logging should be enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether logging is enabled for an AWS WAFv2 web ACL. The control fails if no `aws_wafv2_web_acl_logging_configuration` resource with a matching `resource_arn` is associated with the web ACL, or if the web ACL's `arn` attribute is missing.

Logging is an important part of maintaining the reliability, availability, and performance of AWS WAF globally. It gives you detailed information about the traffic that is analyzed by your web ACL. Logged information includes the time that AWS WAF received a web request from your AWS resource, detailed information about the request, and details about the action for the rules that each request matched. You can use this information for debugging and troubleshooting, as well as to improve your security rules. The logs can be sent to an Amazon CloudWatch Logs log group, an Amazon S3 bucket, or an Amazon Kinesis Data Firehose.

This rule is covered by the [wafv2-webacl-should-have-logging-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/waf/wafv2-webacl-should-have-logging-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # wafv2-webacl-should-have-logging-enabled.policytest.hcl...
      running
      # resource.aws_wafv2_web_acl.pass_logged...
      running
      # resource.aws_wafv2_web_acl.pass_logged...
      pass
      # resource.aws_wafv2_web_acl.fail_not_logged...
      running
      # resource.aws_wafv2_web_acl.fail_not_logged...
      pass
      # resource.aws_wafv2_web_acl.fail_cloudfront_not_logged...
      running
      # resource.aws_wafv2_web_acl.fail_cloudfront_not_logged...
      pass
      # resource.aws_wafv2_web_acl.fail_missing_arn...
      running
      # resource.aws_wafv2_web_acl.fail_missing_arn...
      pass
      # wafv2-webacl-should-have-logging-enabled.policytest.hcl...
      pass
```

---
