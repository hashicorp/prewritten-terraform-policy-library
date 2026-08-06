# SageMaker model bias job definitions should have inter-container traffic encryption enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks whether Amazon SageMaker model bias job definitions have inter-container traffic encryption enabled when using multiple compute instances. The control fails if EnableInterContainerTrafficEncryption is set to false or is not configured for job definitions with an instance count of 2 or greater.

EInter-container traffic encryption protects data transmitted between compute instances during distributed model bias monitoring jobs. Encryption prevents unauthorized access to model-related information such as weights that are transmitted between instances.

This rule is covered by the [sagemaker-model-bias-job-encrypt-in-transit](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/sagemaker/sagemaker-model-bias-job-encrypt-in-transit.policy.hcl) policy.

## Policy Results

```bash
trace:
      # sagemaker-model-bias-job-encrypt-in-transit.policytest.hcl... running
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
      # sagemaker-model-bias-job-encrypt-in-transit.policytest.hcl... pass
```

---
