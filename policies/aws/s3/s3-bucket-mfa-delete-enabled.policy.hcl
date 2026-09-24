# Copyright IBM Corp. 2026

# S3 general purpose buckets should have MFA delete enabled (S3.20)

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "s3-bucket-mfa-delete-enabled-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_s3_bucket" "mfa_delete_enabled" {
  enforcement_level = input.s3-bucket-mfa-delete-enabled-enforcement-level

  locals {
    bucket_name = core::try(attrs.bucket, "")

    versioning_resources = core::getresources("aws_s3_bucket_versioning", {
      bucket = local.bucket_name
    })

    has_versioning = core::length(local.versioning_resources) > 0
    versioning     = local.has_versioning ? local.versioning_resources[0] : null

    versioning_config = core::try(local.versioning.versioning_configuration, [])

    compliant_configs = [
      for config in local.versioning_config : config
      if core::try(config.status, "") == "Enabled" && core::try(config.mfa_delete, "") == "Enabled"
    ]

    is_compliant = local.has_versioning && core::length(local.compliant_configs) > 0
  }

  enforce {
    condition     = local.is_compliant
    error_message = "S3 bucket '${local.bucket_name}' must have an 'aws_s3_bucket_versioning' resource with versioning_configuration.status = 'Enabled' and versioning_configuration.mfa_delete = 'Enabled' to comply with S3.20."
  }
}

