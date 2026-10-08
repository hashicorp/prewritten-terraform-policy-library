# Application Load Balancers should be associated with an AWS WAF web ACL

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Security |

## Description

This control checks whether Application Load Balancers are associated with an AWS WAF web ACL. The control evaluates `aws_wafv2_web_acl_association` resources and fails if the `resource_arn` attribute is absent, null, or an empty string.

Associating an AWS WAF web ACL with an Application Load Balancer adds a layer of protection against common web exploits and bots that may affect availability, compromise security, or consume excessive resources. AWS WAF allows you to define managed and custom rules to filter HTTP/HTTPS traffic based on IP addresses, HTTP headers, HTTP body, URI strings, SQL injection, cross-site scripting (XSS), and more. This helps protect applications from the OWASP Top 10 vulnerabilities and meets security best practices required by frameworks such as PCI DSS and NIST 800-53.

This rule is covered by the [application-load-balancers-should-be-associated-with-an-aws-waf-web-acl](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/elb/application-load-balancers-should-be-associated-with-an-aws-waf-web-acl.policy.hcl) policy.

## Policy Results

```bash
trace:
      # application-load-balancers-should-be-associated-with-an-aws-waf-web-acl.policytest.hcl...
      running
      # resource.aws_wafv2_web_acl_association.pass_constant_alb_arn...
      running
      # resource.aws_wafv2_web_acl_association.pass_constant_alb_arn...
      pass
      # resource.aws_wafv2_web_acl_association.pass_lb_reference_arn...
      running
      # resource.aws_wafv2_web_acl_association.pass_lb_reference_arn...
      pass
      # resource.aws_wafv2_web_acl_association.fail_missing_resource_arn...
      running
      # resource.aws_wafv2_web_acl_association.fail_missing_resource_arn...
      pass
      # resource.aws_wafv2_web_acl_association.fail_null_resource_arn...
      running
      # resource.aws_wafv2_web_acl_association.fail_null_resource_arn...
      pass
      # resource.aws_wafv2_web_acl_association.fail_empty_resource_arn...
      running
      # resource.aws_wafv2_web_acl_association.fail_empty_resource_arn...
      pass
      # application-load-balancers-should-be-associated-with-an-aws-waf-web-acl.policytest.hcl...
      pass
```

---
