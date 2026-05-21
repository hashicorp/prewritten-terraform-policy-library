# EC2.23 - Transit Gateway Auto-Accept VPC Attachments

policy {}

resource_policy "aws_ec2_transit_gateway" "auto_accept_disabled" {
    locals {
        // Safe access to auto_accept_shared_attachments attribute
        auto_accept = core::try(attrs.auto_accept_shared_attachments, "disable")
        
        // Check if auto-accept is disabled (compliant)
        is_compliant = local.auto_accept == "disable"
    }

    enforce {
        condition     = local.is_compliant
        error_message = "Transit Gateway must not automatically accept shared VPC attachments. Current setting: '${local.auto_accept}'. Set 'auto_accept_shared_attachments' to 'disable' or omit it (defaults to 'disable'). Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ec2-controls.html#ec2-23 for more details."
    }
}
