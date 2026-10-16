# Network Load Balancers should have cross-zone load balancing enabled

| Provider | Category |
| ------------------- | -------- |
| Amazon Web Services | Resilience |

## Description

This policy checks if cross-zone load balancing is enabled on Network Load Balancers (NLBs). The policy fails if cross-zone load balancing is not enabled for an NLB.

The policy evaluates `aws_lb` resources.

This rule is covered by the [elb-nlb-cross-zone-load-balancing-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/elb/elb-nlb-cross-zone-load-balancing-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      #
      elb-nlb-cross-zone-load-balancing-enabled.policytest.hcl...
      running
      # resource.aws_lb.pass_nlb_cross_zone_enabled...
      running
      # resource.aws_lb.pass_nlb_cross_zone_enabled...
      pass
      # resource.aws_lb.fail_nlb_cross_zone_disabled...
      running
      # resource.aws_lb.fail_nlb_cross_zone_disabled...
      pass
      # resource.aws_lb.fail_nlb_cross_zone_missing...
      running
      # resource.aws_lb.fail_nlb_cross_zone_missing...
      pass
      # resource.aws_lb.fail_nlb_cross_zone_null...
      running
      # resource.aws_lb.fail_nlb_cross_zone_null...
      pass
      # resource.aws_lb.pass_alb_out_of_scope...
      running
      # resource.aws_lb.pass_alb_out_of_scope...
      pass
      # resource.aws_lb.pass_gwlb_out_of_scope...
      running
      # resource.aws_lb.pass_gwlb_out_of_scope...
      pass
      #
      resource.aws_lb.pass_type_omitted_defaults_application...
      running
      #
      resource.aws_lb.pass_type_omitted_defaults_application...
      pass
      #
      elb-nlb-cross-zone-load-balancing-enabled.policytest.hcl...
      pass
```

---
