# Copyright IBM Corp. 2026

# Ensure rotation for customer-created symmetric CMKs is enabled

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "kms-key-rotation-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_kms_key" "kms_key_rotation_enabled" {

  locals {
    key_spec_raw          = core::try(attrs.customer_master_key_spec, null)
    is_symmetric          = local.key_spec_raw == null || local.key_spec_raw == "" || local.key_spec_raw == "SYMMETRIC_DEFAULT"
    rotation_enabled      = core::try(attrs.enable_key_rotation, false)
  }

  filter = local.is_symmetric

  enforcement_level = input.kms-key-rotation-enabled-enforcement-level
  enforce {
    condition     = local.rotation_enabled == true
    error_message = "Customer-managed symmetric KMS keys must enable automatic key rotation by setting enable_key_rotation to true."
  }
}
