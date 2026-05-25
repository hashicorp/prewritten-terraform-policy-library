# Policy: MSK.4 - MSK clusters should have public access disabled

policy {}

resource_policy "aws_msk_cluster" "public_access_disabled" {
    locals {
        # Safe access to connectivity_info with null handling
        connectivity_info = core::try(attrs.broker_node_group_info[0].connectivity_info, null)
        
        # Safe access to public_access configuration
        public_access = core::try(local.connectivity_info[0].public_access, null)
        
        # Get the public access type (defaults to null if not specified)
        public_access_type = core::try(local.public_access[0].type, null)

        # Check if public access is explicitly enabled
        is_public_enabled = local.public_access_type == "SERVICE_PROVIDED_EIPS"
    }

    enforce {
        condition = !local.is_public_enabled
        error_message = "MSK cluster has public access enabled. Public access type is set to '${local.public_access_type}'. For security, public access must be disabled (set type to 'DISABLED' or remove the public_access configuration block entirely). Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/msk-controls.html#msk-4 for more details."
    }
}
