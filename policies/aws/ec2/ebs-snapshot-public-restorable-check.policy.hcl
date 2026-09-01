# Copyright IBM Corp. 2026

# Amazon EBS snapshots should not be configured to be publicly restorable

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.62.0, < 7.0.0"
    }
  }
}

input "ebs-snapshot-public-restorable-check-enforcement-level" {
  type = string
  default = "advisory"
}

# Policy to validate the block public access resource configuration
resource_policy "aws_ebs_snapshot_block_public_access" "validate_state" {
  enforcement_level = input.ebs-snapshot-public-restorable-check-enforcement-level
  
  locals {
    # Safe access to state attribute
    state_value = core::try(attrs.state, "")
    is_fully_blocked = local.state_value == "block-all-sharing"
  }
  
  enforce {
    condition = local.is_fully_blocked
    error_message = "EBS snapshot block public access resource has an invalid state. Must be 'block-all-sharing' or 'block-new-sharing' to comply with EC2.1"
  }
}
