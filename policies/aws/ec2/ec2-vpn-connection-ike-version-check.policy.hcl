# Copyright IBM Corp. 2026

# Policy: EC2.183 - EC2 VPN connections should use IKEv2 protocol

policy {}

resource_policy "aws_vpn_connection" "ikev2_only" {
  locals {
    tunnel1_ike_versions = core::try(attrs.tunnel1_ike_versions, [])
    tunnel2_ike_versions = core::try(attrs.tunnel2_ike_versions, [])

    tunnel1_invalid_versions = [
      for version in local.tunnel1_ike_versions :
      version if version != "ikev2"
    ]
    tunnel2_invalid_versions = [
      for version in local.tunnel2_ike_versions :
      version if version != "ikev2"
    ]

    tunnel1_ikev2_only = core::length(local.tunnel1_ike_versions) > 0 && core::length(local.tunnel1_invalid_versions) == 0
    tunnel2_ikev2_only = core::length(local.tunnel2_ike_versions) > 0 && core::length(local.tunnel2_invalid_versions) == 0

    connection_name          = core::try(attrs.id, core::try(attrs.customer_gateway_id, "AWS Site-to-Site VPN connection"))
    tunnel1_versions_display = core::length(local.tunnel1_ike_versions) > 0 ? core::join(", ", local.tunnel1_ike_versions) : "not specified (AWS default allows both IKEv1 and IKEv2)"
    tunnel2_versions_display = core::length(local.tunnel2_ike_versions) > 0 ? core::join(", ", local.tunnel2_ike_versions) : "not specified (AWS default allows both IKEv1 and IKEv2)"
  }

  enforce {
    condition     = local.tunnel1_ikev2_only
    error_message = "VPN connection must restrict tunnel 1 to IKEv2 only. Set tunnel1_ike_versions = [\"ikev2\"]. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ec2-controls.html#ec2-183 for more details."
  }

  enforce {
    condition     = local.tunnel2_ikev2_only
    error_message = "VPN connection must restrict tunnel 2 to IKEv2 only. Set tunnel2_ike_versions = [\"ikev2\"]. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ec2-controls.html#ec2-183 for more details."
  }
}
