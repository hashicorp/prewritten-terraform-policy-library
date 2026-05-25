# Both VPN tunnels for an AWS Site-to-Site VPN connection should be up

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | High availability |

## Description

A VPN tunnel is an encrypted link where data can pass from the customer network to or from AWS within an AWS Site-to-Site VPN connection. Each VPN connection includes two VPN tunnels which you can simultaneously use for high availability. Ensuring that both VPN tunnels are up for a VPN connection is important for confirming a secure and highly available connection between an AWS VPC and your remote network.

This control checks that both VPN tunnels provided by AWS Site-to-Site VPN are in UP status. The control fails if one or both tunnels are in DOWN status.

This rule is covered by the [vpc-vpn-2-tunnels-up](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/vpc/vpc-vpn-2-tunnels-up.policy.hcl) policy.

## Policy Results

```bash
trace:
      # vpc-vpn-2-tunnels-up.policytest.hcl...
      running
      # resource.aws_vpn_connection.pass_both_tunnels_up...
      running
      # resource.aws_vpn_connection.pass_both_tunnels_up...
      pass
      # resource.aws_vpn_connection.fail_one_tunnel_down...
      running
      # resource.aws_vpn_connection.fail_one_tunnel_down...
      pass
      # resource.aws_vpn_connection.fail_both_tunnels_down...
      running
      # resource.aws_vpn_connection.fail_both_tunnels_down...
      pass
      # resource.aws_vpn_connection.fail_only_one_tunnel...
      running
      # resource.aws_vpn_connection.fail_only_one_tunnel...
      pass
      # resource.aws_vpn_connection.filtered_empty_telemetry...
      running
      # resource.aws_vpn_connection.filtered_empty_telemetry...
      pass
      # vpc-vpn-2-tunnels-up.policytest.hcl...
      pass
```

---
