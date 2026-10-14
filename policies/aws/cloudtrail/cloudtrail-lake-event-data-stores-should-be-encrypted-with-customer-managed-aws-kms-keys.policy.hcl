# Copyright IBM Corp. 2026

# CloudTrail Lake event data stores should be encrypted with customer managed AWS KMS keys

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.65.0, < 7.0.0"
    }
  }
}

input "cloudtrail-lake-event-data-stores-should-be-encrypted-with-customer-managed-aws-kms-keys-enforcement-level" {
  type    = string
  default = "advisory"
}

input "cloudtrailLakeKmsKeyArns" {
  type    = list(string)
  default = []
}

resource_policy "aws_cloudtrail_event_data_store" "encrypted_with_kms_key" {
  locals {
    kms_key_id_raw = core::try(attrs.kms_key_id, null)
    kms_key_set    = local.kms_key_id_raw != null && local.kms_key_id_raw != ""
    is_aws_managed_alias = local.kms_key_set ? core::length(core::regexall("^alias/aws/", core::lower(local.kms_key_id_raw))) > 0 : false
    is_allowed_key = (
      core::length(input.cloudtrailLakeKmsKeyArns) == 0
      ? true
      : local.kms_key_set
      ? core::contains(input.cloudtrailLakeKmsKeyArns, local.kms_key_id_raw)
      : false
    )
  }
  enforcement_level = input.cloudtrail-lake-event-data-stores-should-be-encrypted-with-customer-managed-aws-kms-keys-enforcement-level
  enforce {
    condition     = local.kms_key_set && !local.is_aws_managed_alias && local.is_allowed_key
    error_message = "CloudTrail Event Data Stores must use a customer-managed KMS key. Specify a non-AWS-managed key in 'kms_key_id' and, when configured, include it in the 'cloudtrailLakeKmsKeyArns' allowlist."
  }
}
