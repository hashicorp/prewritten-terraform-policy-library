# Copyright IBM Corp. 2026

# SageMaker.12 - SageMaker model bias job definitions should have network isolation enabled

policy {}

resource_policy "aws_sagemaker_monitoring_schedule" "model_bias_isolation" {
    filter = attrs.monitoring_schedule_config != null && core::length(attrs.monitoring_schedule_config) > 0

    locals {
        schedule_config = attrs.monitoring_schedule_config[0]
        monitoring_type = core::try(local.schedule_config.monitoring_type, "")
        is_model_bias = local.monitoring_type == "ModelBias"
        
        job_definition = core::try(local.schedule_config.monitoring_job_definition, null)
        has_job_definition = local.job_definition != null ? core::length(local.job_definition) > 0 : false
        
        network_config = local.has_job_definition ? core::try(local.job_definition[0].network_config, null) : null
        has_network_config = local.network_config != null ? core::length(local.network_config) > 0 : false
        
        isolation_enabled = local.has_network_config ? core::try(local.network_config[0].enable_network_isolation, false) : false
    }

    enforce {
        condition = !local.is_model_bias || !local.has_job_definition || (local.has_network_config && local.isolation_enabled == true)
        error_message = "SageMaker model bias monitoring schedule does not have network isolation enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/sagemaker-controls.html#sagemaker-12 for more details."
    }
}
