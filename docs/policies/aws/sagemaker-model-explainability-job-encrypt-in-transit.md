# SageMaker model explainability job definitions should have inter-container traffic encryption enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks whether an Amazon SageMaker model explainability job definition has inter-container traffic encryption enabled. The control fails if the model explainability job definition does not have inter-container traffic encryption enabled.

Enabling inter-container traffic encryption protects sensitive ML data such as model data, training datasets, intermediate processing results, parameters and model weights during distributed processing for explainability analysis.

This rule is covered by the [sagemaker-model-explainability-job-encrypt-in-transit](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/sagemaker/sagemaker-model-explainability-job-encrypt-in-transit.policy.hcl) policy.

## Policy Results

```bash
trace:
      # sagemaker-model-explainability-job-encrypt-in-transit.policytest.hcl... running
      # resource.aws_sagemaker_monitoring_schedule.pass_encryption_enabled... running
      # resource.aws_sagemaker_monitoring_schedule.pass_encryption_enabled... pass
      # resource.aws_sagemaker_monitoring_schedule.fail_encryption_disabled... running
      # resource.aws_sagemaker_monitoring_schedule.fail_encryption_disabled... pass
      # resource.aws_sagemaker_monitoring_schedule.fail_encryption_not_specified... running
      # resource.aws_sagemaker_monitoring_schedule.fail_encryption_not_specified... pass
      # resource.aws_sagemaker_monitoring_schedule.filtered_no_inline_job_definition... running
      # resource.aws_sagemaker_monitoring_schedule.filtered_no_inline_job_definition... pass
      # resource.aws_sagemaker_monitoring_schedule.filtered_different_type... running
      # resource.aws_sagemaker_monitoring_schedule.filtered_different_type... pass
      # sagemaker-model-explainability-job-encrypt-in-transit.policytest.hcl... pass
```

---
