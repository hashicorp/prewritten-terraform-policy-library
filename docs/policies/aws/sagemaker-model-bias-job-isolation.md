# SageMaker model bias job definitions should have network isolation enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resources policy configuration |

## Description

This control checks whether a SageMaker model bias job definition has network isolation enabled. The control fails if model bias job definition does not have network isolation enabled.

Network isolation prevents SageMaker model bias jobs from communicating with external resources over the internet. By enabling network isolation, you ensure that the job's containers cannot make outbound connections, reducing the attack surface and protecting sensitive data from exfiltration. This is particularly important for jobs processing regulated or sensitive data.

This rule is covered by the [sagemaker-model-bias-job-isolation](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/sagemaker/sagemaker-model-bias-job-isolation.policy.hcl) policy.

## Policy Results

```bash
trace:
      # sagemaker-model-bias-job-isolation.policytest.hcl... running
      # resource.aws_sagemaker_monitoring_schedule.pass_isolation_enabled... running
      # resource.aws_sagemaker_monitoring_schedule.pass_isolation_enabled... pass
      # resource.aws_sagemaker_monitoring_schedule.fail_isolation_disabled... running
      # resource.aws_sagemaker_monitoring_schedule.fail_isolation_disabled... pass
      # resource.aws_sagemaker_monitoring_schedule.fail_model_bias_no_network_config... running
      # resource.aws_sagemaker_monitoring_schedule.fail_model_bias_no_network_config... pass
      # resource.aws_sagemaker_monitoring_schedule.pass_data_quality_monitoring... running
      # resource.aws_sagemaker_monitoring_schedule.pass_data_quality_monitoring... pass
      # resource.aws_sagemaker_monitoring_schedule.pass_no_inline_job_definition... running
      # resource.aws_sagemaker_monitoring_schedule.pass_no_inline_job_definition... pass
      # sagemaker-model-bias-job-isolation.policytest.hcl... pass
```

---
