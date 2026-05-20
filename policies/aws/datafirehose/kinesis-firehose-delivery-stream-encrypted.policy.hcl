// DataFirehose.1 - Firehose delivery streams should be encrypted at rest

policy {}

resource_policy "aws_kinesis_firehose_delivery_stream" "encryption_at_rest_required" {
    locals {
        // Check if server_side_encryption block exists and is enabled
        sse_block = core::try(attrs.server_side_encryption, null)
        sse_enabled = local.sse_block != null ? core::try(local.sse_block[0].enabled, false) : false
        
        // Check if kinesis stream is configured as source (exception case)
        has_kinesis_source = core::try(attrs.kinesis_source_configuration, null) != null
    }

    // Skip enforcement if Kinesis stream is the source (exception case)
    filter = !local.has_kinesis_source

    enforce {
        condition = local.sse_enabled == true
        error_message = "Firehose delivery stream must have server-side encryption enabled. Configure the 'server_side_encryption' block with 'enabled = true' to encrypt data at rest. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/datafirehose-controls.html#datafirehose-1 for more details."
    }
}
