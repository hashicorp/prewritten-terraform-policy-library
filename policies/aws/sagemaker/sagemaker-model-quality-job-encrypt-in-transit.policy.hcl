# Copyright IBM Corp. 2026

# SageMaker model quality job definitions should have inter-container traffic encryption enabled

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.63.0, < 7.0.0"
    }
  }
}

input "sagemaker-model-quality-job-encrypt-in-transit-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_sagemaker_monitoring_schedule" "model_quality_encryption" {
    enforcement_level = input.sagemaker-model-quality-job-encrypt-in-transit-enforcement-level

    locals {
        monitoring_schedule_config_raw = core::try(attrs.monitoring_schedule_config, null)
        monitoring_schedule_config = local.monitoring_schedule_config_raw != null ? local.monitoring_schedule_config_raw : []
        monitoring_type = core::try(local.monitoring_schedule_config[0].monitoring_type, "")
        is_model_quality = local.monitoring_type == "ModelQuality"

        job_definition_raw = core::try(local.monitoring_schedule_config[0].monitoring_job_definition, null)
        job_definition = local.job_definition_raw != null ? local.job_definition_raw : []
        has_job_definition = core::length(local.job_definition) > 0

        network_config_raw = core::try(local.job_definition[0].network_config, null)
        network_config = local.network_config_raw != null ? local.network_config_raw : []
        has_network_config = core::length(local.network_config) > 0

        encryption_enabled = core::try(local.network_config[0].enable_inter_container_traffic_encryption, false)
    }

    enforce {
        condition = !local.is_model_quality || (local.is_model_quality && local.encryption_enabled == true)
        error_message = "SageMaker model quality monitoring schedule does not have inter-container traffic encryption enabled. Set 'monitoring_schedule_config.monitoring_job_definition.network_config.enable_inter_container_traffic_encryption = true' to protect data transmitted between containers during distributed model quality monitoring jobs"
    }
}
