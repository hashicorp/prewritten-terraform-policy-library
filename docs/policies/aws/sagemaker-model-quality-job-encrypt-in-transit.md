# SageMaker model quality job definitions should have inter-container traffic encryption enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks whether Amazon SageMaker model quality job definitions have encryption in transit enabled for inter-container traffic. The control fails if a model quality job definition does not have inter-container traffic encryption enabled.

Inter-container traffic encryption protects data transmitted between containers during distributed model quality monitoring jobs. By default, inter-container traffic is unencrypted. Enabling encryption helps maintain data confidentiality during processing and supports compliance with regulatory requirements for data in transit protection.

This rule is covered by the [sagemaker-model-quality-job-encrypt-in-transit](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/sagemaker/sagemaker-model-quality-job-encrypt-in-transit.policy.hcl) policy.

## Policy Results

```bash
trace:
      # sagemaker-model-quality-job-encrypt-in-transit.policytest.hcl... running
      # resource.aws_sagemaker_monitoring_schedule.pass_encryption_enabled... running
      # resource.aws_sagemaker_monitoring_schedule.pass_encryption_enabled... pass
      # resource.aws_sagemaker_monitoring_schedule.fail_encryption_disabled... running
      # resource.aws_sagemaker_monitoring_schedule.fail_encryption_disabled... pass
      # resource.aws_sagemaker_monitoring_schedule.fail_no_network_config... running
      # resource.aws_sagemaker_monitoring_schedule.fail_no_network_config... pass
      # resource.aws_sagemaker_monitoring_schedule.pass_data_quality_monitoring... running
      # resource.aws_sagemaker_monitoring_schedule.pass_data_quality_monitoring... pass
      # resource.aws_sagemaker_monitoring_schedule.pass_no_inline_job_definition... running
      # resource.aws_sagemaker_monitoring_schedule.pass_no_inline_job_definition... pass
      # sagemaker-model-quality-job-encrypt-in-transit.policytest.hcl... pass
```

---
