# Classic Load Balancers should have connection draining enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resilience |

## Description

This control checks whether Classic Load Balancers have connection draining enabled.

Enabling connection draining on Classic Load Balancers ensures that the load balancer stops sending requests to instances that are de-registering or unhealthy. It keeps the existing connections open. This is particularly useful for instances in Auto Scaling groups, to ensure that connections aren't severed abruptly.

This rule is covered by the [elb-connection-draining-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/elasticloadbalancing/elb-connection-draining-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # elb-connection-draining-enabled.policytest.hcl...
      running
      # resource.aws_elb.compliant...
      running
      # resource.aws_elb.compliant...
      pass
      # resource.aws_elb.non_compliant_disabled...
      running
      # resource.aws_elb.non_compliant_disabled...
      pass
      # resource.aws_elb.non_compliant_default...
      running
      # resource.aws_elb.non_compliant_default...
      pass
      # elb-connection-draining-enabled.policytest.hcl...
      pass
```

---