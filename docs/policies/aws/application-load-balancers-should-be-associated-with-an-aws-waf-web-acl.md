# Application Load Balancers should be associated with an AWS WAF web ACL

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Security |

## Description

This control checks whether each Application Load Balancer is associated with an AWS WAF web ACL through a matching `aws_wafv2_web_acl_association` or `aws_wafregional_web_acl_association`. Network and Gateway Load Balancers are not evaluated. For new ALBs, the ARN may be unknown during plan evaluation, preventing the policy from matching the association until the ARN is known.

| Parameter | Description | Type | Default |
| --- | --- | --- | --- |
| `application-load-balancers-should-be-associated-with-an-aws-waf-web-acl-enforcement-level` | Configurable policy enforcement level. | `string` | `"advisory"` |

Associating an AWS WAF web ACL with an Application Load Balancer adds a layer of protection against common web exploits and bots that may affect availability, compromise security, or consume excessive resources. AWS WAF allows you to define managed and custom rules to filter HTTP/HTTPS traffic based on IP addresses, HTTP headers, HTTP body, URI strings, SQL injection, cross-site scripting (XSS), and more. This helps protect applications from the OWASP Top 10 vulnerabilities and meets security best practices required by frameworks such as PCI DSS and NIST 800-53.

This rule is covered by the [application-load-balancers-should-be-associated-with-an-aws-waf-web-acl](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/elb/application-load-balancers-should-be-associated-with-an-aws-waf-web-acl.policy.hcl) policy.

## Policy Results

```bash
trace:
      # application-load-balancers-should-be-associated-with-an-aws-waf-web-acl.policytest.hcl...
      running
      # resource.aws_lb.pass_associated_alb...
      running
      # resource.aws_lb.pass_associated_alb...
      pass
      # resource.aws_lb.pass_default_type_alb...
      running
      # resource.aws_lb.pass_default_type_alb...
      pass
      # resource.aws_lb.fail_unassociated_alb...
      running
      # resource.aws_lb.fail_unassociated_alb...
      pass
      # resource.aws_lb.pass_second_associated_alb...
      running
      # resource.aws_lb.pass_second_associated_alb...
      pass
      # resource.aws_lb.skip_network_load_balancer...
      running
      # resource.aws_lb.skip_network_load_balancer...
      pass
      # application-load-balancers-should-be-associated-with-an-aws-waf-web-acl.policytest.hcl...
      pass
```

---
