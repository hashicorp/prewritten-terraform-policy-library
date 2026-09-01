# Copyright IBM Corp. 2026

# SageMaker data quality job definitions should have inter-container traffic encryption enabled

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.63.0, < 7.0.0"
    }
  }
}

input "sagemaker-data-quality-job-encrypt-in-transit-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_sagemaker_data_quality_job_definition" "inter_container_encryption" {
    enforcement_level = input.sagemaker-data-quality-job-encrypt-in-transit-enforcement-level

    locals {
      network_config_raw = core::try(attrs.network_config, null)
      network_config = local.network_config_raw != null ? local.network_config_raw : []
      data_quality_encryption = core::try(local.network_config[0].enable_inter_container_traffic_encryption, false)
    }

    enforce {
        condition = local.data_quality_encryption == true
        error_message = "SageMaker data quality job definition does not have inter-container traffic encryption enabled. Set 'network_config.enable_inter_container_traffic_encryption = true' to protect sensitive ML data during distributed processing"
    }
}
