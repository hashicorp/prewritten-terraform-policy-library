# Copyright IBM Corp. 2026

# MSK Connect connectors should be encrypted in transit

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.8.0, < 7.0.0"
    }
  }
}

input "msk-connect-connector-encrypted-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_mskconnect_connector" "encryption_in_transit_required" {
    enforcement_level = input.msk-connect-connector-encrypted-enforcement-level

    locals {
        kafka_encryption_in_transit_raw = core::try(attrs.kafka_cluster_encryption_in_transit, null)
        kafka_encryption_in_transit = local.kafka_encryption_in_transit_raw != null ? local.kafka_encryption_in_transit_raw : []
        
        # Extract encryption type with safe fallback
        encryption_type = core::try(local.kafka_encryption_in_transit[0].encryption_type, "PLAINTEXT")
        
        # Check if encryption is properly configured
        is_encrypted = local.encryption_type == "TLS"
    }

    enforce {
        condition = local.is_encrypted
        error_message = "MSK Connect connector must have encryption in transit enabled. Current encryption_type: '${local.encryption_type}'. Set kafka_cluster_encryption_in_transit.encryption_type to 'TLS' to meet security best practices"
    }
}
