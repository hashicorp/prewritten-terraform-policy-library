# AWS WAF Classic Regional web ACLs should have at least one rule or rule group

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure network configuration |

## Description

This control checks whether an AWS WAF Classic Regional web ACL contains any WAF rules or WAF rule groups. This control fails if a web ACL does not contain any WAF rules or rule groups.

A WAF Regional web ACL can contain a collection of rules and rule groups that inspect and control web requests. If a web ACL is empty, the web traffic can pass without being detected or acted upon by WAF depending on the default action.

This rule is covered by the [waf-regional-webacl-not-empty](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/waf/waf-regional-webacl-not-empty.policy.hcl) policy.

## Policy Results

```bash
trace:
      # waf-regional-webacl-not-empty.policytest.hcl... running
      # resource.aws_wafregional_web_acl.pass_with_single_rule... running
      # resource.aws_wafregional_web_acl.pass_with_single_rule... pass
      # resource.aws_wafregional_web_acl.fail_with_empty_rules... running
      # resource.aws_wafregional_web_acl.fail_with_empty_rules... pass
      # resource.aws_wafregional_web_acl.pass_with_multiple_rules... running
      # resource.aws_wafregional_web_acl.pass_with_multiple_rules... pass
      # resource.aws_wafregional_web_acl.fail_with_no_rules... running
      # resource.aws_wafregional_web_acl.fail_with_no_rules... pass
      # waf-regional-webacl-not-empty.policytest.hcl... pass
```

---
