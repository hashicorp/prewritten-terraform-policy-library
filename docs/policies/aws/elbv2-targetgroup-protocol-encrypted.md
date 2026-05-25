# ELB target groups should use encrypted transport protocols

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks whether an Elastic Load Balancing target group uses an encrypted transport protocol. This control does not apply to target groups with a target type of Lambda or ALB, or target groups using the GENEVE protocol. The control fails if the target group does not use HTTPS, TLS, or QUIC protocol.

Encrypting data in transit protects it from interception by unauthorized users. Target groups that use unencrypted protocols (HTTP, TCP, UDP) transmit data without encryption, making it vulnerable to eavesdropping. Using encrypted protocols (HTTPS, TLS, QUIC) ensures that data transmitted between load balancers and targets is protected.

This rule is covered by the [elbv2-targetgroup-protocol-encrypted](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/elb/elbv2-targetgroup-protocol-encrypted.policy.hcl) policy.

## Policy Results

```bash
trace:
      # elbv2-targetgroup-protocol-encrypted.policytest.hcl... running
      # resource.aws_lb_target_group.https_instance_pass... running
      # resource.aws_lb_target_group.https_instance_pass... pass
      # resource.aws_lb_target_group.tls_ip_pass... running
      # resource.aws_lb_target_group.tls_ip_pass... pass
      # resource.aws_lb_target_group.quic_instance_pass... running
      # resource.aws_lb_target_group.quic_instance_pass... pass
      # resource.aws_lb_target_group.http_instance_fail... running
      # resource.aws_lb_target_group.http_instance_fail... pass
      # resource.aws_lb_target_group.tcp_ip_fail... running
      # resource.aws_lb_target_group.tcp_ip_fail... pass
      # resource.aws_lb_target_group.udp_instance_fail... running
      # resource.aws_lb_target_group.udp_instance_fail... pass
      # resource.aws_lb_target_group.geneve_excluded_pass... running
      # resource.aws_lb_target_group.geneve_excluded_pass... pass
      # resource.aws_lb_target_group.lambda_excluded_pass... running
      # resource.aws_lb_target_group.lambda_excluded_pass... pass
      # resource.aws_lb_target_group.alb_excluded_pass... running
      # resource.aws_lb_target_group.alb_excluded_pass... pass
      # elbv2-targetgroup-protocol-encrypted.policytest.hcl... pass
```

---
