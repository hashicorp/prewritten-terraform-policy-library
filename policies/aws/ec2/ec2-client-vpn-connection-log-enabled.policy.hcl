# EC2.51 - EC2 Client VPN endpoints should have client connection logging enabled.

policy {}

resource_policy "aws_ec2_client_vpn_endpoint" "connection_logging_enabled" {
    enforce {
        condition = core::try(attrs.connection_log_options[0].enabled, false) == true
        error_message = "Client VPN endpoint does not have connection logging enabled. Set 'connection_log_options.enabled = true' to track user activity and provide visibility. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ec2-controls.html#ec2-51 for more details."
    }
}