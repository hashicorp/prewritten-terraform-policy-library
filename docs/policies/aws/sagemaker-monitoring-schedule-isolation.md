# SageMaker monitoring schedules should have network isolation enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure network configuration |

## Description

This control checks whether Amazon SageMaker monitoring schedules have network isolation enabled. The control fails if a monitoring schedule has EnableNetworkIsolation set to false or not configured

Network isolation prevents monitoring jobs from making outbound network calls, reducing the attack surface by eliminating internet access from containers.

This rule is covered by the [sagemaker-monitoring-schedule-isolation](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/sagemaker/sagemaker-monitoring-schedule-isolation.policy.hcl) policy.

## Policy Results

```bash
trace:
      # sagemaker-monitoring-schedule-isolation.policytest.hcl... running
      # resource.aws_sagemaker_monitoring_schedule.monitoring_schedule_inline_enabled... running
      # resource.aws_sagemaker_monitoring_schedule.monitoring_schedule_inline_enabled... pass
      # resource.aws_sagemaker_monitoring_schedule.monitoring_schedule_inline_disabled... running
      # resource.aws_sagemaker_monitoring_schedule.monitoring_schedule_inline_disabled... pass
      # resource.aws_sagemaker_monitoring_schedule.monitoring_schedule_inline_no_config... running
      # resource.aws_sagemaker_monitoring_schedule.monitoring_schedule_inline_no_config... pass
      # resource.aws_sagemaker_data_quality_job_definition.data_quality_enabled... running
      # resource.aws_sagemaker_data_quality_job_definition.data_quality_enabled... pass
      # resource.aws_sagemaker_data_quality_job_definition.data_quality_disabled... running
      # resource.aws_sagemaker_data_quality_job_definition.data_quality_disabled... pass
      # resource.aws_sagemaker_data_quality_job_definition.data_quality_no_config... running
      # resource.aws_sagemaker_data_quality_job_definition.data_quality_no_config... pass
      # sagemaker-monitoring-schedule-isolation.policytest.hcl... pass
```

---
