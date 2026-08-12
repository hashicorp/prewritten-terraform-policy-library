# EC2 Client VPN endpoints should have client connection logging enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether an AWS Client VPN endpoint has client connection logging enabled. The control fails if the endpoint doesn't have client connection logging enabled.

Client VPN endpoints allow remote clients to securely connect to resources in a Virtual Private Cloud (VPC) in AWS. Connection logs allow you to track user activity on the VPN endpoint and provides visibility. When you enable connection logging, you can specify the name of a log stream in the log group. If you don't specify a log stream, the Client VPN service creates one for you.

This rule is covered by the [ec2-client-vpn-connection-log-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/ec2/ec2-client-vpn-connection-log-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ec2-client-vpn-connection-log-enabled.policytest.hcl... running
      # resource.aws_ec2_client_vpn_endpoint.pass_logging_enabled... running
      # resource.aws_ec2_client_vpn_endpoint.pass_logging_enabled... pass
      # resource.aws_ec2_client_vpn_endpoint.fail_logging_disabled... running
      # resource.aws_ec2_client_vpn_endpoint.fail_logging_disabled... pass
      # resource.aws_ec2_client_vpn_endpoint.fail_logging_explicitly_false... running
      # resource.aws_ec2_client_vpn_endpoint.fail_logging_explicitly_false... pass
      # resource.aws_ec2_client_vpn_endpoint.pass_logging_with_log_group... running
      # resource.aws_ec2_client_vpn_endpoint.pass_logging_with_log_group... pass
      # ec2-client-vpn-connection-log-enabled.policytest.hcl... pass
```

---
