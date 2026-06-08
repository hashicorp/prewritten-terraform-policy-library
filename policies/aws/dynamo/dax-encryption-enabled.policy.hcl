# Copyright IBM Corp. 2026

# Policy: DynamoDB.3 - DynamoDB Accelerator (DAX) clusters should be encrypted at rest

policy {}

resource_policy "aws_dax_cluster" "encryption_at_rest_required" {
    locals {
        # Safely access the server_side_encryption block
        # The server_side_encryption attribute is a list of objects (block)
        sse_config = core::try(attrs.server_side_encryption, [])
        
        # Check if the block exists and has at least one element
        has_sse_block = core::length(local.sse_config) > 0
        
        # Check if encryption is enabled (defaults to false if not set)
        encryption_enabled = local.has_sse_block && core::try(local.sse_config[0].enabled, false)
    }

    enforce {
        condition     = local.encryption_enabled == true
        error_message = "DAX cluster '${meta.address}' must have encryption at rest enabled. Set server_side_encryption.enabled = true in the cluster configuration. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/dynamodb-controls.html#dynamodb-3 for more details."
    }
}
