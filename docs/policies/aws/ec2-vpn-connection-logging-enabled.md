# EC2 VPN connections should have logging enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether an AWS Site-to-Site VPN connection has Amazon CloudWatch Logs enabled for both tunnels. The control fails if a Site-to-Site VPN connection doesn't have CloudWatch Logs enabled for both tunnels.

AWS Site-to-Site VPN logs provide you with deeper visibility into your Site-to-Site VPN deployments. With this feature, you have access to Site-to-Site VPN connection logs that provide details on IP Security (IPsec) tunnel establishment, Internet Key Exchange (IKE) negotiations, and dead peer detection (DPD) protocol messages. Site-to-Site VPN logs can be published to CloudWatch Logs. This feature provides customers with a single consistent way to access and analyze detailed logs for all of their Site-to-Site VPN connections.

This rule is covered by the [ec2-vpn-connection-logging-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/ec2/ec2-vpn-connection-logging-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ec2-vpn-connection-logging-enabled.policytest.hcl... running
      # resource.aws_vpn_connection.pass_both_tunnels_logging_enabled... running
      # resource.aws_vpn_connection.pass_both_tunnels_logging_enabled... pass
      # resource.aws_vpn_connection.fail_tunnel1_logging_disabled... running
      # resource.aws_vpn_connection.fail_tunnel1_logging_disabled... pass
      # resource.aws_vpn_connection.fail_tunnel2_logging_disabled... running
      # resource.aws_vpn_connection.fail_tunnel2_logging_disabled... pass
      # resource.aws_vpn_connection.fail_both_tunnels_logging_disabled... running
      # resource.aws_vpn_connection.fail_both_tunnels_logging_disabled... pass
      # resource.aws_vpn_connection.fail_tunnel1_empty_log_group_arn... running
      # resource.aws_vpn_connection.fail_tunnel1_empty_log_group_arn... pass
      # resource.aws_vpn_connection.fail_tunnel2_empty_log_group_arn... running
      # resource.aws_vpn_connection.fail_tunnel2_empty_log_group_arn... pass
      # resource.aws_vpn_connection.fail_both_empty_log_group_arns... running
      # resource.aws_vpn_connection.fail_both_empty_log_group_arns... pass
      # resource.aws_vpn_connection.fail_tunnel1_empty_log_options... running
      # resource.aws_vpn_connection.fail_tunnel1_empty_log_options... pass
      # resource.aws_vpn_connection.fail_tunnel2_empty_log_options... running
      # resource.aws_vpn_connection.fail_tunnel2_empty_log_options... pass
      # resource.aws_vpn_connection.fail_both_empty_log_options... running
      # resource.aws_vpn_connection.fail_both_empty_log_options... pass
      # resource.aws_vpn_connection.fail_tunnel1_missing_log_options... running
      # resource.aws_vpn_connection.fail_tunnel1_missing_log_options... pass
      # resource.aws_vpn_connection.fail_tunnel2_missing_log_options... running
      # resource.aws_vpn_connection.fail_tunnel2_missing_log_options... pass
      # resource.aws_vpn_connection.fail_both_missing_log_options... running
      # resource.aws_vpn_connection.fail_both_missing_log_options... pass
      # ec2-vpn-connection-logging-enabled.policytest.hcl... pass
```

---
