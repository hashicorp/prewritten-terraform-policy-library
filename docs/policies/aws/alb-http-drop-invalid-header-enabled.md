# Application Load Balancer should be configured to drop invalid http headers

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Network Security |

## Description

This control evaluates whether an Application Load Balancer is configured to drop invalid HTTP headers. The control fails if the value of routing.http.drop_invalid_header_fields.enabled is set to false.

By default, Application Load Balancers are not configured to drop invalid HTTP header values. Removing these header values prevents HTTP desync attacks.

We recommend disabling this control if ELB.12 is enabled in your account. For more information, see [ELB.12] Application Load Balancer should be configured with defensive or strictest desync mitigation mode.

This rule is covered by the [alb-http-drop-invalid-header-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/elb/alb-http-drop-invalid-header-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # alb-http-drop-invalid-header-enabled.policytest.hcl... running
      # resource.aws_lb.application_lb_compliant... running
      # resource.aws_lb.application_lb_compliant... pass
      # resource.aws_lb.application_lb_non_compliant... running
      # resource.aws_lb.application_lb_non_compliant... pass
      # resource.aws_lb.application_lb_non_compliant... running
      # resource.aws_lb.application_lb_non_compliant... pass
      # resource.aws_lb.network_lb_not_applicable... running
      # resource.aws_lb.network_lb_not_applicable... pass
      # alb-http-drop-invalid-header-enabled.policytest.hcl... pass
```

---
