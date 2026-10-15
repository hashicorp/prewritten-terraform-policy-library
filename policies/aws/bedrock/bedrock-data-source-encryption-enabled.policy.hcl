# Copyright IBM Corp. 2026

# Amazon Bedrock data sources should be encrypted with customer managed AWS KMS keys

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "bedrock-data-source-encryption-enabled-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_bedrockagent_data_source" "encrypted_with_cmk" {
  enforcement_level = input.bedrock-data-source-encryption-enabled-enforcement-level

  # Security Hub does not evaluate data sources that belong to a managed knowledge base.
  filter = core::length(core::try([
    for c in attrs.data_source_configuration : c
    if core::try(c.type, "") == "MANAGED_KNOWLEDGE_BASE_CONNECTOR" || core::try(core::length(c.managed_knowledge_base_connector_configuration), 0) > 0
  ], [])) == 0

  locals {
    key_raw = core::try(attrs.server_side_encryption_configuration[0].kms_key_arn, null)
    key_arn = local.key_raw == null ? "" : core::trimspace(local.key_raw)
    # AWS managed key aliases (alias/aws/...) are not customer managed keys
    is_aws_managed = core::length(core::regexall("alias/aws/", local.key_arn)) > 0
  }

  enforce {
    condition     = local.key_arn != "" && !local.is_aws_managed
    error_message = "Amazon Bedrock data sources must be encrypted with a customer managed AWS KMS key. Set 'server_side_encryption_configuration.kms_key_arn' to a customer managed key."
  }
}
