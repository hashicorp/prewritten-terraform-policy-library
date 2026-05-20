# SageMaker.9 - SageMaker data quality job definitions should have inter-container traffic encryption enabled.

policy {}

resource_policy "aws_sagemaker_data_quality_job_definition" "inter_container_encryption" {
    filter = core::try(attrs.network_config, null) != null

    enforce {
        condition = core::try(attrs.network_config[0].enable_inter_container_traffic_encryption, false) == true
        error_message = "SageMaker data quality job definition does not have inter-container traffic encryption enabled. Set 'network_config.enable_inter_container_traffic_encryption = true' to protect sensitive ML data during distributed processing. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/sagemaker-controls.html#sagemaker-9 for more details."
    }
}
