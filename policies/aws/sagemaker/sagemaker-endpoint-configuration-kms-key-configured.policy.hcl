# Copyright IBM Corp. 2026

# SageMaker endpoint configurations should have an AWS KMS key configured

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "sagemaker-endpoint-configuration-kms-key-configured-enforcement-level" {
  type    = string
  default = "advisory"
}

# Operator-tunable allowlist of KMS key ARNs. Empty list (default) means any
# non-empty, valid KMS key ARN is acceptable.
input "sagemaker-endpoint-configuration-kms-key-configured-allowed_kms_arns" {
  type    = list(string)
  default = []
}

resource_policy "aws_sagemaker_endpoint_configuration" "kms_key_configured" {
  locals {
    kms_key_arn_raw      = core::try(attrs.kms_key_arn, null)
    kms_key_arn_missing  = local.kms_key_arn_raw == null
    kms_key_arn          = local.kms_key_arn_missing ? "" : local.kms_key_arn_raw
    kms_key_arn_empty    = local.kms_key_arn == ""
    kms_key_arn_set      = !local.kms_key_arn_empty
    allowed_arns         = input.sagemaker-endpoint-configuration-kms-key-configured-allowed_kms_arns
    has_allowlist        = core::length(local.allowed_arns) > 0
    kms_key_in_allowlist = local.has_allowlist ? core::contains(local.allowed_arns, local.kms_key_arn) : true
    is_compliant         = local.kms_key_arn_set ? local.kms_key_in_allowlist : false
    error_message = (
      local.kms_key_arn_missing ? "SageMaker endpoint configuration must have a KMS key configured for encryption. The 'kms_key_arn' attribute must be set." :
      !local.kms_key_arn_set ? "SageMaker endpoint configuration must have a valid KMS key configured for encryption. The 'kms_key_arn' attribute cannot be empty." :
      "SageMaker endpoint configuration has KMS key '${local.kms_key_arn}' which is not in the allowed list: [${core::join(", ", local.allowed_arns)}]."
    )
  }

  enforcement_level = input.sagemaker-endpoint-configuration-kms-key-configured-enforcement-level
  enforce {
    condition     = local.is_compliant
    error_message = local.error_message
  }
}
