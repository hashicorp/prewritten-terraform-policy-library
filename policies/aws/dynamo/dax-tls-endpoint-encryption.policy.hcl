# Copyright IBM Corp. 2026

# DynamoDB.7 - DynamoDB Accelerator clusters should be encrypted in transit

policy {}

input "dax-tls-endpoint-encryption-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_dax_cluster" "dax_tls_encryption" {
    enforcement_level = input.dax-tls-endpoint-encryption-enforcement-level
    locals {
        # Safe access to cluster_endpoint_encryption_type with default "NONE"
        encryption_type = core::try(attrs.cluster_endpoint_encryption_type, "NONE")
        
        # Check if TLS is enabled
        is_tls_enabled = local.encryption_type == "TLS"
    }

    enforce {
        condition     = local.is_tls_enabled
        error_message = "DAX cluster must have cluster_endpoint_encryption_type set to 'TLS'. Current value: '${local.encryption_type}'. HTTPS (TLS) helps prevent attackers from eavesdropping on or manipulating network traffic using person-in-the-middle attacks. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/dynamodb-controls.html#dynamodb-7 for more details."
    }
}
