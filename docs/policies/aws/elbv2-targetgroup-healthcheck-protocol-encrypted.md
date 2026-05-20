# Application and Network Load Balancer target groups should use encrypted health check protocols

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks whether the target group for application and network load balancer health checks use an encrypted transport protocol. The control fails if the health check protocol does not use HTTPS. This control is not applicable to Lambda target types.

Load Balancers send health check requests to registered targets to determine their status and route traffic accordingly. The health check protocol specified in the target group configuration determines how these checks are performed. When health check protocols use unencrypted communication such as HTTP, the requests and responses can be intercepted or manipulated during transmission. This allows attackers to gain insights into infrastructure configuration, tamper with health check results, or conduct man-in-the-middle attacks that affect routing decisions. Using HTTPS for health checks provides encrypted communication between the load balancer and its targets, protecting the integrity and confidentiality of health status information.

This rule is covered by the [elbv2-targetgroup-healthcheck-protocol-encrypted](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/elb/elbv2-targetgroup-healthcheck-protocol-encrypted.policy.hcl) policy.

## Policy Results

```bash
trace:
      # elbv2-targetgroup-healthcheck-protocol-encrypted.policytest.hcl... running
      # resource.aws_lb_target_group.alb_https... running
      # resource.aws_lb_target_group.alb_https... pass
      # resource.aws_lb_target_group.nlb_https... running
      # resource.aws_lb_target_group.nlb_https... pass
      # resource.aws_lb_target_group.http... running
      # resource.aws_lb_target_group.http... pass
      # resource.aws_lb_target_group.tcp... running
      # resource.aws_lb_target_group.tcp... pass
      # resource.aws_lb_target_group.no_health_check... running
      # resource.aws_lb_target_group.no_health_check... pass
      # resource.aws_lb_target_group.empty_hc... running
      # resource.aws_lb_target_group.empty_hc... pass
      # elbv2-targetgroup-healthcheck-protocol-encrypted.policytest.hcl... pass
```

---
