# SageMaker endpoint production variants should have an initial instance count greater than 1

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | High availability |

## Description

This control checks whether production variants of an Amazon SageMaker AI endpoint have an initial instance count greater than 1. The control fails if the endpoint's production variants have only 1 initial instance.

Production variants running with an instance count greater than 1 permit multi-AZ instance redundancy managed by SageMaker AI. Deploying resources across multiple Availability Zones is an AWS best practice to provide high availability within your architecture. High availability helps you to recover from security incidents.

This control applies only to instance-based endpoint configuration.

This rule is covered by the [sagemaker-endpoint-config-prod-instance-count](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/sagemaker/sagemaker-endpoint-config-prod-instance-count.policy.hcl) policy.

## Policy Results

```bash
trace:
      # sagemaker-endpoint-config-prod-instance-count.policytest.hcl... running
      # resource.aws_sagemaker_endpoint_configuration.pass_single_variant_count_2... running
      # resource.aws_sagemaker_endpoint_configuration.pass_single_variant_count_2... pass
      # resource.aws_sagemaker_endpoint_configuration.fail_single_variant_count_1... running
      # resource.aws_sagemaker_endpoint_configuration.fail_single_variant_count_1... pass
      # resource.aws_sagemaker_endpoint_configuration.fail_missing_instance_count... running
      # resource.aws_sagemaker_endpoint_configuration.fail_missing_instance_count... pass
      # resource.aws_sagemaker_endpoint_configuration.pass_serverless_variant... running
      # resource.aws_sagemaker_endpoint_configuration.pass_serverless_variant... pass
      # resource.aws_sagemaker_endpoint_configuration.pass_multiple_variants_all_compliant... running
      # resource.aws_sagemaker_endpoint_configuration.pass_multiple_variants_all_compliant... pass
      # resource.aws_sagemaker_endpoint_configuration.fail_multiple_variants_one_non_compliant... running
      # resource.aws_sagemaker_endpoint_configuration.fail_multiple_variants_one_non_compliant... pass
      # resource.aws_sagemaker_endpoint_configuration.fail_shadow_variant_count_1... running
      # resource.aws_sagemaker_endpoint_configuration.fail_shadow_variant_count_1... pass
      # resource.aws_sagemaker_endpoint_configuration.pass_shadow_variant_count_3... running
      # resource.aws_sagemaker_endpoint_configuration.pass_shadow_variant_count_3... pass
      # resource.aws_sagemaker_endpoint_configuration.pass_mixed_instance_and_serverless... running
      # resource.aws_sagemaker_endpoint_configuration.pass_mixed_instance_and_serverless... pass
      # sagemaker-endpoint-config-prod-instance-count.policytest.hcl... pass
```

---
