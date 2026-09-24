# Ensure routing tables for VPC peering are least access

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure network configuration |

## Description

This control checks whether route table entries that target a VPC peering connection are scoped to specific destinations.

A peering connection is not transitive, but a route is as broad as the CIDR written next to it. Pointing `0.0.0.0/0` or `::/0` at a peering connection extends reachability to the whole of the peer VPC rather than to the handful of hosts the integration actually needs, which defeats the segmentation the VPC boundary was meant to provide.

The policy rejects any route that combines `vpc_peering_connection_id` with a catch-all destination CIDR, requiring the most specific block that satisfies the use case.

This rule is covered by the [vpc-peering-least-access](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/ec2/vpc-peering-least-access.policy.hcl) policy.

## Policy Results

```bash
trace:
      # vpc-peering-least-access.policytest.hcl... running
      # resource.aws_route.pass_specific_cidr... running
      # resource.aws_route.pass_specific_cidr... pass
      # resource.aws_route.pass_specific_16_cidr... running
      # resource.aws_route.pass_specific_16_cidr... pass
      # resource.aws_route.pass_specific_ipv6_cidr... running
      # resource.aws_route.pass_specific_ipv6_cidr... pass
      # resource.aws_route.pass_non_peering_route... running
      # resource.aws_route.pass_non_peering_route... pass
      # resource.aws_route.pass_no_peering_id... running
      # resource.aws_route.pass_no_peering_id... pass
      # resource.aws_route.fail_catch_all_ipv4... running
      # resource.aws_route.fail_catch_all_ipv4... pass
      # resource.aws_route.fail_catch_all_ipv6... running
      # resource.aws_route.fail_catch_all_ipv6... pass
      # vpc-peering-least-access.policytest.hcl... pass
```

---
