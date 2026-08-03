# Copyright IBM Corp. 2026

# EMR.3 - Amazon EMR security configurations should be encrypted at rest.

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "emr-security-configuration-encryption-rest-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_emr_security_configuration" "emr-security-configuration-encryption-rest" {
    enforcement_level = input.emr-security-configuration-encryption-rest-enforcement-level
    locals {
        config = core::jsondecode(attrs.configuration)
    }

    enforce {
        condition = core::try(local.config.EncryptionConfiguration.EnableAtRestEncryption, false)
        error_message = "The EMR security configuration does not have the encryption at rest enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/emr-controls.html#emr-3 for more details."
    }
}
