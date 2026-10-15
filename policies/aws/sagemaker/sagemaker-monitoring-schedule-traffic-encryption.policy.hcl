# Copyright IBM Corp. 2026

# SageMaker monitoring schedules should have inter-container traffic encryption enabled

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "sagemaker-monitoring-schedule-traffic-encryption-enforcement-level" {
  type    = string
  default = "advisory"
}

# Data quality job definitions in the plan that a schedule can reference through
# monitoring_job_definition_name. Model quality, model bias and model explainability job
# definitions only exist in hashicorp/awscc, and tfpolicy 0.4.0 cannot look up awscc resources
# from an aws resource policy, so schedules that reference those are not evaluated.
locals {
  monitoring_schedule_data_quality_definitions = [
    for d in core::getresources("aws_sagemaker_data_quality_job_definition", {}) : {
      name    = core::try(d.name, "")
      enabled = core::try(d.network_config[0].enable_inter_container_traffic_encryption, null) == true
    }
  ]
}

resource_policy "aws_sagemaker_monitoring_schedule" "inter_container_traffic_encryption" {
  enforcement_level = input.sagemaker-monitoring-schedule-traffic-encryption-enforcement-level

  locals {
    # Compare lengths, not the block against null: the inline definition has computed fields,
    # so a null comparison is unknown at plan time.
    has_inline_definition = core::try(core::length(attrs.monitoring_schedule_config[0].monitoring_job_definition), 0) > 0
    inline_enabled        = core::try(attrs.monitoring_schedule_config[0].monitoring_job_definition[0].network_config[0].enable_inter_container_traffic_encryption, null) == true

    definition_name_raw = core::try(attrs.monitoring_schedule_config[0].monitoring_job_definition_name, null)
    definition_name     = local.definition_name_raw == null ? "" : local.definition_name_raw
    referenced = [
      for d in local.monitoring_schedule_data_quality_definitions : d
      if local.definition_name != "" && d.name == local.definition_name
    ]
    referenced_disabled = core::length([for d in local.referenced : d if !d.enabled]) > 0

    # Encryption defaults to false when network_config or the flag is omitted. A schedule that
    # references a job definition outside this plan cannot be evaluated and is not reported.
    is_compliant = local.has_inline_definition ? local.inline_enabled : !local.referenced_disabled
  }

  enforce {
    condition     = local.is_compliant
    error_message = "SageMaker monitoring schedules must have inter-container traffic encryption enabled. Set 'network_config.enable_inter_container_traffic_encryption = true' in the monitoring job definition."
  }
}
