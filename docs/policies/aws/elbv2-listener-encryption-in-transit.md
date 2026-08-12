# Application and Network Load Balancer listeners should use secure protocols to encrypt data in transit

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks whether the listener for an Application Load Balancer or Network Load Balancer is configured to use a secure protocol for encryption of data in transit. The control fails if an Application Load Balancer listener isn't configured to use the HTTPS protocol, or a Network Load Balancer listener isn't configured to use the TLS protocol.

To encrypt data that's transmitted between a client and a load balancer, Elastic Load Balancer listeners should be configured to use industry-standard security protocols: HTTPS for Application Load Balancers, or TLS for Network Load Balancers. Otherwise, data that's transmitted between a client and a load balancer is vulnerable to interception, tampering, and unauthorized access. Use of HTTPS or TLS by a listener aligns with security best practices and helps ensure the confidentiality and integrity of data during transmission. This is particularly important for applications that handle sensitive information, or must comply with security standards that require encryption of data in transit.

This rule is covered by the [elbv2-listener-encryption-in-transit](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/elb/elbv2-listener-encryption-in-transit.policy.hcl) policy.

## Policy Results

```bash
trace:
      # elbv2-listener-encryption-in-transit.policytest.hcl... running
      # resource.aws_lb_listener.alb_https_pass... running
      # resource.aws_lb_listener.alb_https_pass... pass
      # resource.aws_lb_listener.alb_http_fail... running
      # resource.aws_lb_listener.alb_http_fail... pass
      # resource.aws_lb_listener.nlb_tls_pass... running
      # resource.aws_lb_listener.nlb_tls_pass... pass
      # resource.aws_lb_listener.nlb_tcp_fail... running
      # resource.aws_lb_listener.nlb_tcp_fail... pass
      # resource.aws_lb_listener.nlb_udp_fail... running
      # resource.aws_lb_listener.nlb_udp_fail... pass
      # resource.aws_lb_listener.alb_tls_fail... running
      # resource.aws_lb_listener.alb_tls_fail... pass
      # elbv2-listener-encryption-in-transit.policytest.hcl... pass
```

---
