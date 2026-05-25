# Classic Load Balancers should have cross-zone load balancing enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | High availability |

## Description

This control checks if cross-zone load balancing is enabled for the Classic Load Balancers (CLBs). The control fails if cross-zone load balancing is not enabled for a CLB.

A load balancer node distributes traffic only across the registered targets in its Availability Zone. When cross-zone load balancing is disabled, each load balancer node distributes traffic only across the registered targets in its Availability Zone. If the number of registered targets is not same across the Availability Zones, traffic wont be distributed evenly and the instances in one zone may end up over utilized compared to the instances in another zone. With cross-zone load balancing enabled, each load balancer node for your Classic Load Balancer distributes requests evenly across the registered instances in all enabled Availability Zones. For details see Cross-zone load balancing in the Elastic Load Balancing User Guide.

This rule is covered by the [elb-cross-zone-load-balancing-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/elb/elb-cross-zone-load-balancing-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # elb-cross-zone-load-balancing-enabled.policytest.hcl... running
      # resource.aws_elb.explicit_true... running
      # resource.aws_elb.explicit_true... pass
      # resource.aws_elb.default_value... running
      # resource.aws_elb.default_value... pass
      # resource.aws_elb.explicit_false... running
      # resource.aws_elb.explicit_false... pass
      # elb-cross-zone-load-balancing-enabled.policytest.hcl... pass
```

---
