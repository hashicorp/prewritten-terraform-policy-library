# Copyright IBM Corp. 2026

# CloudWatch log groups should be encrypted with AWS KMS keys

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "cloudwatch-log-group-kms-encryption-enforcement-level" {
  type    = string
  default = "advisory"
}

input "cloudwatch-log-group-kms-encryption-kms_key_id" {
  type        = string
  default     = ""
  description = "Optional ARN of the KMS key required to encrypt CloudWatch Log Groups. If empty, any KMS key is acceptable as long as one is configured."
}

resource_policy "aws_cloudwatch_log_group" "cloudwatch_log_group_kms_encryption" {
  enforcement_level = input.cloudwatch-log-group-kms-encryption-enforcement-level

  locals {
    required_kms_key_id = input.cloudwatch-log-group-kms-encryption-kms_key_id

    kms_key_id_raw = core::try(attrs.kms_key_id, null)
    kms_key_id     = local.kms_key_id_raw == null ? "" : local.kms_key_id_raw

    has_kms_key_id  = local.kms_key_id != ""
    kms_key_matches = local.required_kms_key_id == "" || local.kms_key_id == local.required_kms_key_id
    is_compliant    = local.has_kms_key_id && local.kms_key_matches

    violation_message = local.required_kms_key_id == "" ? (
      "CloudWatch Log Group must be encrypted with an AWS KMS key. Attribute 'kms_key_id' is not set"
      ) : (
      local.kms_key_id == "" ? (
        "CloudWatch Log Group must be encrypted with AWS KMS key '${local.required_kms_key_id}'. Attribute 'kms_key_id' is not set"
        ) : (
        "CloudWatch Log Group must be encrypted with AWS KMS key '${local.required_kms_key_id}'. Current value is '${local.kms_key_id}'"
      )
    )
  }

  enforce {
    condition     = local.is_compliant
    error_message = local.violation_message
  }
}
