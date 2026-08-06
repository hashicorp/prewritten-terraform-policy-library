# Application, Gateway, and Network Load Balancers should have deletion protection enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | High availability |

## Description

This control checks whether an Application, Gateway, or Network Load Balancer has deletion protection enabled. The control fails if deletion protection is disabled.

Enable deletion protection to protect your Application, Gateway, or Network Load Balancer from deletion.

This rule is covered by the [elb-deletion-protection-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/elb/elb-deletion-protection-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # elb-deletion-protection-enabled.policytest.hcl... running
      # resource.aws_lb.alb_protected... running
      # resource.aws_lb.alb_protected... pass
      # resource.aws_lb.nlb_protected... running
      # resource.aws_lb.nlb_protected... pass
      # resource.aws_lb.gwlb_protected... running
      # resource.aws_lb.gwlb_protected... pass
      # resource.aws_lb.alb_unprotected... running
      # resource.aws_lb.alb_unprotected... pass
      # resource.aws_lb.nlb_unprotected... running
      # resource.aws_lb.nlb_unprotected... pass
      # resource.aws_lb.gwlb_unprotected... running
      # resource.aws_lb.gwlb_unprotected... pass
      # resource.aws_lb.alb_default... running
      # resource.aws_lb.alb_default... pass
      # elb-deletion-protection-enabled.policytest.hcl... pass
```

---
