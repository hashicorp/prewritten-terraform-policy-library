# AWS WAF rules should have CloudWatch metrics enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether an AWS WAF rule or rule group has Amazon CloudWatch metrics enabled. The control fails if the rule or rule group doesn't have CloudWatch metrics enabled.

Configuring CloudWatch metrics on AWS WAF rules and rule groups provides visibility into traffic flow. You can see which ACL rules are triggered and which requests are accepted and blocked. This visibility can help you identify malicious activity on your associated resources.

This rule is covered by the [wafv2-rulegroup-logging-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/waf/wafv2-rulegroup-logging-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # wafv2-rulegroup-logging-enabled.policytest.hcl...
      running
      # resource.aws_wafv2_rule_group.compliant_rule_group...
      running
      # resource.aws_wafv2_rule_group.compliant_rule_group...
      pass
      # resource.aws_wafv2_rule_group.rule_group_metrics_disabled...
      running
      # resource.aws_wafv2_rule_group.rule_group_metrics_disabled...
      pass
      # resource.aws_wafv2_rule_group.rule_group_missing_rule_visibility...
      running
      # resource.aws_wafv2_rule_group.rule_group_missing_rule_visibility...
      pass
      # resource.aws_wafv2_web_acl.compliant_web_acl...
      running
      # resource.aws_wafv2_web_acl.compliant_web_acl...
      pass
      # resource.aws_wafv2_web_acl.web_acl_rule_metrics_disabled...
      running
      # resource.aws_wafv2_web_acl.web_acl_rule_metrics_disabled...
      pass
      # wafv2-rulegroup-logging-enabled.policytest.hcl...
      pass
```

---