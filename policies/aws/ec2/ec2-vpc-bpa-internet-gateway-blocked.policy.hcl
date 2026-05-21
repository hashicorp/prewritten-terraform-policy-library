# EC2.172 - EC2 VPC Block Public Access settings should block internet gateway traffic
policy {}

input "vpcBpaInternetGatewayBlockMode" {
    type = string
    default = ""
}

resource_policy "aws_vpc_block_public_access_options" "ec2_172_vpc_bpa_igw_block" {
    locals {
        # Safe access to internet_gateway_block_mode attribute
        igw_block_mode = core::try(attrs.internet_gateway_block_mode, "off")
        
        # List of allowed modes
        allowed_modes = ["block-bidirectional", "block-ingress"]

        has_target_mode_input = input.vpcBpaInternetGatewayBlockMode != ""
        valid_target_mode_input = !local.has_target_mode_input || core::contains(local.allowed_modes, input.vpcBpaInternetGatewayBlockMode)
        
        # Check if mode is compliant
        is_compliant = core::contains(local.allowed_modes, local.igw_block_mode)
        matches_target_mode = !local.has_target_mode_input || local.igw_block_mode == input.vpcBpaInternetGatewayBlockMode
    }

    enforce {
        condition = local.valid_target_mode_input
        error_message = "input.vpcBpaInternetGatewayBlockMode must be one of 'block-bidirectional' or 'block-ingress' when provided. Current value: '${input.vpcBpaInternetGatewayBlockMode}'. Leave it empty to accept either compliant mode."
    }

    enforce {
        condition = local.is_compliant
        error_message = "VPC Block Public Access settings must have InternetGatewayBlockMode set to 'block-bidirectional' or 'block-ingress'. Current mode: '${local.igw_block_mode}'. Configuring VPC BPA settings blocks resources in VPCs and subnets from reaching or being reached from the internet through internet gateways and egress-only internet gateways. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ec2-controls.html#ec2-172 for more details."
    }

    enforce {
        condition = local.matches_target_mode
        error_message = "VPC Block Public Access settings must have InternetGatewayBlockMode set to '${input.vpcBpaInternetGatewayBlockMode}' when input.vpcBpaInternetGatewayBlockMode is provided. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ec2-controls.html#ec2-172 for more details."
    }
}
