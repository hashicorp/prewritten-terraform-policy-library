# Policy: EC2.20 - Both VPN tunnels for an AWS Site-to-Site VPN connection should be up

policy {}

resource_policy "aws_vpn_connection" "vpn_tunnels_up" {
    # Filter to only evaluate VPN connections that have telemetry data
    # Check both null and that array is not empty
    filter = attrs.vgw_telemetry != null && core::length(attrs.vgw_telemetry) > 0

    locals {
        # Extract telemetry data safely - must handle null case
        telemetry = attrs.vgw_telemetry != null ? attrs.vgw_telemetry : []
        
        # Get status of each tunnel (should be exactly 2 tunnels)
        tunnel_statuses = [for t in local.telemetry : core::try(t.status, "UNKNOWN")]
        
        # Count how many tunnels are UP
        up_tunnels = [for status in local.tunnel_statuses : status if status == "UP"]
        up_count = core::length(local.up_tunnels)
        
        # Count total tunnels
        total_tunnels = core::length(local.tunnel_statuses)
        
        # Check if both tunnels are up
        both_tunnels_up = local.up_count == 2 && local.total_tunnels == 2
        
        # Get tunnel addresses for error messages
        tunnel1_address = core::try(attrs.tunnel1_address, "unknown")
        tunnel2_address = core::try(attrs.tunnel2_address, "unknown")
        
        # Create detailed status message
        status_details = core::join(", ", [
            for i, status in local.tunnel_statuses :
            "Tunnel ${i + 1}: ${status}"
        ])
    }

    enforce {
        condition = local.both_tunnels_up
        error_message = "VPN connection does not have both tunnels in UP status. Current status: ${local.status_details}. Both VPN tunnels must be UP to ensure high availability and secure connectivity. Tunnel addresses: ${local.tunnel1_address}, ${local.tunnel2_address}. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ec2-controls.html#ec2-20 for more details."
    }

    enforce {
        condition = local.total_tunnels == 2
        error_message = "VPN connection has ${local.total_tunnels} tunnel(s) configured, but exactly 2 tunnels are required for AWS Site-to-Site VPN connections. This is a configuration issue that needs immediate attention. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ec2-controls.html#ec2-20 for more details."
    }
}
