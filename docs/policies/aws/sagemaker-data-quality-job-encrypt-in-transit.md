# SageMaker data quality job definitions should have inter-container traffic encryption enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks whether an Amazon SageMaker AI data quality job definition has encryption enabled for inter-container traffic. The control fails if the definition for a job that monitors data quality and drift does not have encryption enabled for inter-container traffic.

Enabling inter-container traffic encryption protects sensitive ML data during distributed processing for data quality analysis.

This rule is covered by the [sagemaker-data-quality-job-encrypt-in-transit](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/sagemaker/sagemaker-data-quality-job-encrypt-in-transit.policy.hcl) policy.

## Policy Results

```bash
trace:
      # sagemaker-data-quality-job-encrypt-in-transit.policytest.hcl... running
      # resource.aws_sagemaker_data_quality_job_definition.encryption_enabled... running
      # resource.aws_sagemaker_data_quality_job_definition.encryption_enabled... pass
      # resource.aws_sagemaker_data_quality_job_definition.encryption_disabled... running
      # resource.aws_sagemaker_data_quality_job_definition.encryption_disabled... pass
      # resource.aws_sagemaker_data_quality_job_definition.no_network_config... running
      # resource.aws_sagemaker_data_quality_job_definition.no_network_config... pass
      # resource.aws_sagemaker_data_quality_job_definition.encryption_not_set... running
      # resource.aws_sagemaker_data_quality_job_definition.encryption_not_set... pass
      # sagemaker-data-quality-job-encrypt-in-transit.policytest.hcl... pass
```

---
