# AWS WAF web ACLs should have at least one rule or rule group

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure network configuration |

## Description

This control checks whether an AWS WAFV2 web access control list (web ACL) contains at least one rule or rule group. The control fails if a web ACL does not contain any rules or rule groups.

A web ACL gives you fine-grained control over all of the HTTP(S) web requests that your protected resource responds to. A web ACL should contain a collection of rules and rule groups that inspect and control web requests. If a web ACL is empty, the web traffic can pass without being detected or acted upon by AWS WAF depending on the default action.

This rule is covered by the [wafv2-webacl-not-empty](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/waf/wafv2-webacl-not-empty.policy.hcl) policy.

## Policy Results

```bash
trace:
      # wafv2-webacl-not-empty.policytest.hcl...
      running
      # resource.aws_wafv2_web_acl.pass_with_single_rule...
      running
      # resource.aws_wafv2_web_acl.pass_with_single_rule...
      pass
      # resource.aws_wafv2_web_acl.pass_with_multiple_rules...
      running
      # resource.aws_wafv2_web_acl.pass_with_multiple_rules...
      pass
      # resource.aws_wafv2_web_acl.fail_with_empty_rules...
      running
      # resource.aws_wafv2_web_acl.fail_with_empty_rules...
      pass
      # resource.aws_wafv2_web_acl.fail_without_rule_attribute...
      running
      # resource.aws_wafv2_web_acl.fail_without_rule_attribute...
      pass
      # wafv2-webacl-not-empty.policytest.hcl...
      pass
```

---