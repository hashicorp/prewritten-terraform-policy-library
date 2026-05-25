# EC2 VPN connections should use IKEv2 protocol

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks whether an AWS Site-to-Site VPN connection is configured to use IKEv2 protocol. The control fails if a VPN connection allows IKEv1 or does not explicitly restrict both tunnels to IKEv2.

The policy evaluates `aws_vpn_connection` resources of type `ipsec.1` and requires both `tunnel1_ike_versions` and `tunnel2_ike_versions` to be explicitly present and to contain only `ikev2`.

IKEv2 provides improved security and stronger cryptographic protections compared to the legacy IKEv1 protocol. Restricting VPN tunnels to IKEv2 reduces attack surface and helps ensure modern encryption standards are used for data in transit.

This rule is covered by the [ec2-vpn-connection-ike-version-check](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/ec2/ec2-vpn-connection-ike-version-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ec2-vpn-connection-ike-version-check.policytest.hcl...
      running
      # resource.aws_vpn_connection.pass_ikev2_only...
      running
      # resource.aws_vpn_connection.pass_ikev2_only...
      pass
      # resource.aws_vpn_connection.fail_tunnel1_allows_ikev1...
      running
      # resource.aws_vpn_connection.fail_tunnel1_allows_ikev1...
      pass
      # resource.aws_vpn_connection.fail_tunnel2_not_specified...
      running
      # resource.aws_vpn_connection.fail_tunnel2_not_specified...
      pass
      # ec2-vpn-connection-ike-version-check.policytest.hcl...
      pass
```

---