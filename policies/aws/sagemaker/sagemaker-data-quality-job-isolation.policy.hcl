# SageMaker.11 - SageMaker data quality job definitions should have network isolation enabled.

policy {}

resource_policy "aws_sagemaker_data_quality_job_definition" "data_quality_network_isolation_enabled" {
    locals {
        network_config = core::try(attrs.network_config, [])
        has_network_config = core::length(local.network_config) > 0
        
        network_isolation_enabled = local.has_network_config ? core::try(local.network_config[0].enable_network_isolation, false) : false
    }

    enforce {
        condition = local.network_isolation_enabled == true
        error_message = "SageMaker data quality job definition does not have network isolation enabled. Set 'network_config.enable_network_isolation = true' to reduce attack surface and prevent unauthorized external access. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/sagemaker-controls.html#sagemaker-11 for more details."
    }
}
