# Copyright IBM Corp. 2026

# EC2 Spot Fleet requests with launch parameters should enable encryption for attached EBS volumes

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.65.0, < 7.0.0"
    }
  }
}

input "ec2-spot-fleet-request-ct-encryption-at-rest-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_spot_fleet_request" "ebs_encryption_required" {
    enforcement_level = input.ec2-spot-fleet-request-ct-encryption-at-rest-enforcement-level
    locals {
        # Extract all launch specifications
        launch_specs = core::try(attrs.launch_specification, [])
        has_launch_specs = core::try(core::length(local.launch_specs) > 0, false)
        
        # root_block_device/ebs_block_device are set-typed blocks in the provider schema
        # (unordered), so they must be iterated with a for-expression rather than
        # indexed with [0].
        unencrypted_root_devices = [
            for idx, spec in local.launch_specs :
            idx if core::length([
                for rbd in (core::try(spec.root_block_device, null) != null ? spec.root_block_device : []) :
                rbd if core::try(rbd.encrypted, false) != true
            ]) > 0
        ]
        
        # Check EBS block devices for encryption - check each spec
        specs_with_unencrypted_ebs = [
            for idx, spec in local.launch_specs :
            idx if core::length([
                for device in (core::try(spec.ebs_block_device, null) != null ? spec.ebs_block_device : []) :
                device if core::try(device.encrypted, false) != true
            ]) > 0
        ]
        
        # Check if there are any unencrypted volumes
        has_unencrypted_root = core::try(core::length(local.unencrypted_root_devices) > 0, false)
        has_unencrypted_ebs = core::try(core::length(local.specs_with_unencrypted_ebs) > 0, false)
    }

    # Enforce that launch specifications are defined
    enforce {
        condition = local.has_launch_specs
        error_message = "Spot Fleet request must have launch_specification blocks defined. EC2.173 requires Spot Fleet requests with launch parameters to enable EBS encryption"
    }

    # Enforce root block device encryption
    enforce {
        condition = !local.has_unencrypted_root
        error_message = "Spot Fleet request has launch specifications with unencrypted root block devices. All EBS volumes must have encryption enabled (encrypted = true)"
    }

    # Enforce EBS block device encryption
    enforce {
        condition = !local.has_unencrypted_ebs
        error_message = "Spot Fleet request has launch specifications with unencrypted EBS block devices. All EBS volumes must have encryption enabled (encrypted = true)"
    }
}