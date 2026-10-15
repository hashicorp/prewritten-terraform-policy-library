# Copyright IBM Corp. 2026

# SageMaker notebook instances should be encrypted with customer managed AWS KMS keys

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "sagemaker-notebook-instance-storage-vol-kms-encrypted-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_sagemaker_notebook_instance" "storage_volume_kms_encrypted" {
  enforcement_level = input.sagemaker-notebook-instance-storage-vol-kms-encrypted-enforcement-level

  locals {
    key_raw = core::try(attrs.kms_key_id, null)
    key_id  = local.key_raw == null ? "" : core::trimspace(local.key_raw)
  }

  enforce {
    condition     = local.key_id != ""
    error_message = "SageMaker notebook instances must be encrypted with a customer managed AWS KMS key. Set 'kms_key_id' on the notebook instance."
  }
}
