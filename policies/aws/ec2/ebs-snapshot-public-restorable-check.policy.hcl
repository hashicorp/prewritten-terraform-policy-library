# Policy: EC2.1 - Amazon EBS snapshots should not be publicly restorable

policy {}

# Policy to validate the block public access resource configuration
resource_policy "aws_ebs_snapshot_block_public_access" "validate_state" {
  
  locals {
    # Safe access to state attribute
    state_value = core::try(attrs.state, "")
    
    # Valid blocking states
    valid_states = ["block-all-sharing", "block-new-sharing"]
    
    # Check if state is valid
    is_valid_state = core::contains(local.valid_states, local.state_value)
  }
  
  enforce {
    condition = local.is_valid_state
    error_message = "EBS snapshot block public access resource has an invalid state. Must be 'block-all-sharing' or 'block-new-sharing' to comply with EC2.1. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ec2-controls.html#ec2-1 for more details."
  }
}