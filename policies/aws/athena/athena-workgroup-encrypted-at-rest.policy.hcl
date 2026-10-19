# Copyright IBM Corp. 2026

# Athena workgroups should be encrypted at rest

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "athena-workgroup-encrypted-at-rest-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_athena_workgroup" "athena_workgroup_encrypted_at_rest" {
  locals {
    configuration_raw = core::try(attrs.configuration, null)
    configuration     = local.configuration_raw != null ? local.configuration_raw : []
    config            = core::length(local.configuration) > 0 ? local.configuration[0] : null

    result_configuration_raw = local.config != null ? core::try(local.config.result_configuration, null) : null
    result_configuration     = local.result_configuration_raw != null ? local.result_configuration_raw : []
    result_config            = core::length(local.result_configuration) > 0 ? local.result_configuration[0] : null

    result_encryption_configuration_raw = local.result_config != null ? core::try(local.result_config.encryption_configuration, null) : null
    result_encryption_configuration     = local.result_encryption_configuration_raw != null ? local.result_encryption_configuration_raw : []
    result_encryption_config            = core::length(local.result_encryption_configuration) > 0 ? local.result_encryption_configuration[0] : null

    result_encryption_option_raw = local.result_encryption_config != null ? core::try(local.result_encryption_config.encryption_option, null) : null
    result_encryption_option     = local.result_encryption_option_raw != null ? local.result_encryption_option_raw : ""

    result_kms_key_arn_raw = local.result_encryption_config != null ? core::try(local.result_encryption_config.kms_key_arn, null) : null
    result_kms_key_arn     = local.result_kms_key_arn_raw != null ? local.result_kms_key_arn_raw : ""

    result_option_is_valid = local.result_encryption_option == "SSE_S3" || local.result_encryption_option == "SSE_KMS" || local.result_encryption_option == "CSE_KMS"
    result_option_is_kms   = local.result_encryption_option == "SSE_KMS" || local.result_encryption_option == "CSE_KMS"

    result_encryption_valid = local.result_encryption_config != null && local.result_option_is_valid && (local.result_option_is_kms ? local.result_kms_key_arn != "" : true)

    managed_configuration_raw = local.config != null ? core::try(local.config.managed_query_results_configuration, null) : null
    managed_configuration     = local.managed_configuration_raw != null ? local.managed_configuration_raw : []
    managed_config            = core::length(local.managed_configuration) > 0 ? local.managed_configuration[0] : null

    managed_enabled_raw = local.managed_config != null ? core::try(local.managed_config.enabled, null) : null
    managed_enabled     = local.managed_enabled_raw == null ? false : local.managed_enabled_raw

    managed_encryption_configuration_raw = local.managed_config != null ? core::try(local.managed_config.encryption_configuration, null) : null
    managed_encryption_configuration     = local.managed_encryption_configuration_raw != null ? local.managed_encryption_configuration_raw : []
    managed_encryption_config            = core::length(local.managed_encryption_configuration) > 0 ? local.managed_encryption_configuration[0] : null

    managed_kms_key_raw = local.managed_encryption_config != null ? core::try(local.managed_encryption_config.kms_key, null) : null
    managed_kms_key     = local.managed_kms_key_raw != null ? local.managed_kms_key_raw : ""

    managed_encryption_valid = local.managed_config != null && local.managed_enabled == true && local.managed_encryption_config != null && local.managed_kms_key != ""

    encryption_enabled = local.result_encryption_valid || local.managed_encryption_valid
  }

  enforcement_level = input.athena-workgroup-encrypted-at-rest-enforcement-level
  enforce {
    condition     = local.encryption_enabled
    error_message = "Amazon Athena workgroup must have encryption enabled at rest"
  }
}
