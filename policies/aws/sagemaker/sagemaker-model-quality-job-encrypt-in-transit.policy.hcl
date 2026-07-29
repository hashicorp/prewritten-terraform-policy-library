# Copyright IBM Corp. 2026

# SageMaker.13 - Model Quality Job Definitions Inter-Container Traffic Encryption.

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0, < 7.0.0"
    }
  }
}

input "sagemaker-model-quality-job-encrypt-in-transit-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_sagemaker_monitoring_schedule" "model_quality_encryption" {
    enforcement_level = input.sagemaker-model-quality-job-encrypt-in-transit-enforcement-level
    filter = attrs.monitoring_schedule_config != null && core::length(attrs.monitoring_schedule_config) > 0

    locals {
        schedule_config = attrs.monitoring_schedule_config[0]
        monitoring_type = core::try(local.schedule_config.monitoring_type, "")
        is_model_quality = local.monitoring_type == "ModelQuality"
        
        job_definition = core::try(local.schedule_config.monitoring_job_definition, null)
        has_job_definition = local.job_definition != null ? core::length(local.job_definition) > 0 : false
        
        network_config = local.has_job_definition ? core::try(local.job_definition[0].network_config, null) : null
        has_network_config = local.network_config != null ? core::length(local.network_config) > 0 : false
        
        encryption_enabled = local.has_network_config ? core::try(local.network_config[0].enable_inter_container_traffic_encryption, false) : false
    }

    enforce {
        condition = !local.is_model_quality || !local.has_job_definition || (local.has_network_config && local.encryption_enabled == true)
        error_message = "SageMaker model quality monitoring schedule does not have inter-container traffic encryption enabled. Set 'monitoring_schedule_config.monitoring_job_definition.network_config.enable_inter_container_traffic_encryption = true' to protect data transmitted between containers during distributed model quality monitoring jobs. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/sagemaker-controls.html#sagemaker-13 for more details."
    }
}
