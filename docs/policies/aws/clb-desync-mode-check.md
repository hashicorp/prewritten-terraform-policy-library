# Classic Load Balancer should be configured with defensive or strictest desync mitigation mode

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Data integrity |

## Description

This control checks whether a Classic Load Balancer is configured with defensive or strictest desync mitigation mode. The control fails if the Classic Load Balancer isn't configured with defensive or strictest desync mitigation mode.

HTTP Desync issues can lead to request smuggling and make applications vulnerable to request queue or cache poisoning. In turn, these vulnerabilities can lead to credential hijacking or execution of unauthorized commands. Classic Load Balancers configured with defensive or strictest desync mitigation mode protect your application from security issues that may be caused by HTTP Desync.

This rule is covered by the [clb-desync-mode-check](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/elasticloadbalancing/clb-desync-mode-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # clb-desync-mode-check.policytest.hcl...
      running
      # resource.aws_elb.pass_defensive_mode...
      running
      # resource.aws_elb.pass_defensive_mode...
      pass
      # resource.aws_elb.pass_strictest_mode...
      running
      # resource.aws_elb.pass_strictest_mode...
      pass
      # resource.aws_elb.pass_default_mode...
      running
      # resource.aws_elb.pass_default_mode...
      pass
      # resource.aws_elb.fail_monitor_mode...
      running
      # resource.aws_elb.fail_monitor_mode...
      pass
      # clb-desync-mode-check.policytest.hcl...
      pass
```

---