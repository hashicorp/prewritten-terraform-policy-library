# EC2.181 - EC2 Launch Templates Should Enable Encryption for Attached EBS Volumes.

policy {}

resource_policy "aws_launch_template" "ebs_encryption_enabled" {
    filter = core::length(core::try(attrs.block_device_mappings, [])) > 0

    locals {
        # Filter for block device mappings that have EBS volumes without encryption
        unencrypted_devices = [
            for mapping in core::try(attrs.block_device_mappings, []) : mapping
            if core::length(core::try(mapping.ebs, [])) > 0 && !core::try(mapping.ebs[0].encrypted, false)
        ]
    }

    enforce {
        condition = core::length(local.unencrypted_devices) == 0
        error_message = "Launch template has EBS volume(s) without encryption enabled. Set 'block_device_mappings.ebs.encrypted = true' for all EBS volumes. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ec2-controls.html#ec2-181 for more details."
    }
}
