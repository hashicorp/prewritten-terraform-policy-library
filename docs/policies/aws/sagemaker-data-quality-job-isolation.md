# SageMaker data quality job definitions should have network isolation enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure network configuration |

## Description

This control checks whether an Amazon SageMaker AI data quality monitoring job definition has network isolation enabled. The control fails if the definition for a job that monitors data quality and drift has network isolation disabled.

Network isolation reduces the attack. surface and prevents external access thereby protecting against unauthorized external access, accidental data exposure and potential data exfiltration.

This rule is covered by the [sagemaker-data-quality-job-isolation](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/sagemaker/sagemaker-data-quality-job-isolation.policy.hcl) policy.

## Policy Results

```bash
trace:
      # sagemaker-data-quality-job-isolation.policytest.hcl... running
      # resource.aws_sagemaker_data_quality_job_definition.pass_with_network_isolation_enabled... running
      # resource.aws_sagemaker_data_quality_job_definition.pass_with_network_isolation_enabled... pass
      # resource.aws_sagemaker_data_quality_job_definition.fail_with_network_isolation_disabled... running
      # resource.aws_sagemaker_data_quality_job_definition.fail_with_network_isolation_disabled... pass
      # resource.aws_sagemaker_data_quality_job_definition.fail_without_network_config... running
      # resource.aws_sagemaker_data_quality_job_definition.fail_without_network_config... pass
      # resource.aws_sagemaker_data_quality_job_definition.fail_with_network_config_but_missing_attribute... running
      # resource.aws_sagemaker_data_quality_job_definition.fail_with_network_config_but_missing_attribute... pass
      # sagemaker-data-quality-job-isolation.policytest.hcl... pass
```

---
