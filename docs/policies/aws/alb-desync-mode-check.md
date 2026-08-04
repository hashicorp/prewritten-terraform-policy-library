# Application Load Balancer should be configured with defensive or strictest desync mitigation mode

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Data integrity |

## Description

This control checks whether an Application Load Balancer is configured with defensive or strictest desync mitigation mode. The control fails if an Application Load Balancer is not configured with defensive or strictest desync mitigation mode.

HTTP Desync issues can lead to request smuggling and make applications vulnerable to request queue or cache poisoning. In turn, these vulnerabilities can lead to credential stuffing or execution of unauthorized commands. Application Load Balancers configured with defensive or strictest desync mitigation mode protect your application from security issues that may be caused by HTTP Desync.

This rule is covered by the [alb-desync-mode-check](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/elb/alb-desync-mode-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # alb-desync-mode-check.policytest.hcl... running
      # resource.aws_lb.compliant_defensive... running
      # resource.aws_lb.compliant_defensive... pass
      # resource.aws_lb.compliant_strictest... running
      # resource.aws_lb.compliant_strictest... pass
      # resource.aws_lb.compliant_default... running
      # resource.aws_lb.compliant_default... pass
      # resource.aws_lb.non_compliant_monitor... running
      # resource.aws_lb.non_compliant_monitor... pass
      # resource.aws_lb.network_lb... running
      # resource.aws_lb.network_lb... pass
      # alb-desync-mode-check.policytest.hcl... pass
```

---
