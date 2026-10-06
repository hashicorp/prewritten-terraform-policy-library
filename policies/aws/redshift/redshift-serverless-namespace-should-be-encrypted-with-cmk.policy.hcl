# Copyright IBM Corp. 2026

# Redshift Serverless namespaces should be encrypted with a customer-managed KMS key

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "redshift-serverless-namespace-should-be-encrypted-with-cmk-enforcement-level" {
  type    = string
  default = "advisory"
}

input "redshift-serverless-kmsKeyArns" {
  type    = string
  default = ""
}

resource_policy "aws_redshiftserverless_namespace" "redshift_serverless_namespace_should_be_encrypted_with_cmk" {
  locals {
    kms_key_id_raw = core::try(attrs.kms_key_id, null)
    has_kms_key    = local.kms_key_id_raw != null && local.kms_key_id_raw != ""

    kms_key_arns_input = core::trimspace(input.redshift-serverless-kmsKeyArns)
    has_arn_filter     = local.kms_key_arns_input != ""
    allowed_arns       = local.has_arn_filter ? [for arn in core::split(",", local.kms_key_arns_input) : core::trimspace(arn)] : []

    # When a filter list is provided, the key must be one of the listed ARNs.
    # When no filter is provided, any non-empty kms_key_id is sufficient.
    key_in_allowed_list = local.has_arn_filter ? core::contains(local.allowed_arns, local.kms_key_id_raw) : true
  }

  enforcement_level = input.redshift-serverless-namespace-should-be-encrypted-with-cmk-enforcement-level
  enforce {
    condition     = local.has_kms_key && local.key_in_allowed_list
    error_message = "Attribute 'kms_key_id' must be present for 'aws_redshiftserverless_namespace' resources${local.has_arn_filter ? " and must be one of the allowed KMS key ARNs: ${input.redshift-serverless-kmsKeyArns}" : ""}"
  }
}
