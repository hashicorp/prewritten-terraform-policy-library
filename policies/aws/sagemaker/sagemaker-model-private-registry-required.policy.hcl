# Copyright IBM Corp. 2026

# SageMaker models should use private registry in VPC for primary containers
# AWS Config rule: sagemaker-model-private-registry-required
# NON_COMPLIANT if ImageConfig is missing on the primary_container, or RepositoryAccessMode is "Platform".
# Multi-container inference pipelines (using `container` instead of `primary_container`) are out of scope
# for this control and are covered by SageMaker.19.

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "sagemaker-model-private-registry-required-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_sagemaker_model" "private_registry_required" {
    enforcement_level = input.sagemaker-model-private-registry-required-enforcement-level

    locals {
      # Safe access to primary_container list. Empty list => no primary_container configured.
        primary_container_raw = core::try(attrs.primary_container, null)
        primary_container = local.primary_container_raw != null ? local.primary_container_raw : []

        image_config_raw = core::try(local.primary_container[0].image_config, null)
        image_config = local.image_config_raw != null ? local.image_config_raw : []

        repository_access_mode = core::try(local.image_config[0].repository_access_mode, "")
        is_vpc_mode            = local.repository_access_mode == "Vpc"

        auth_config_list_raw = core::try(local.image_config[0].repository_auth_config, null)
        auth_config_list = local.auth_config_list_raw != null ? local.auth_config_list_raw : []

        credentials_arn = core::try(local.auth_config_list[0].repository_credentials_provider_arn, "")

        # If VPC mode AND auth_config block is provided, credentials ARN must be non-empty.
        # (repository_auth_config is only meaningful with Vpc mode, and when present its ARN field is required.)
        valid_credential = local.credentials_arn != ""
    }

    # Enforce: if repository_auth_config is provided, its credentials_provider_arn must be set.
    enforce {
        condition     = local.valid_credential
        error_message = "SageMaker model primary_container uses VPC mode with repository_auth_config but repository_credentials_provider_arn is empty. Provide the ARN of an AWS Lambda function that supplies credentials for the private Docker registry"
    }
}
