# SageMaker endpoint configurations should have an AWS KMS key configured

| Provider | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This policy checks if AWS Key Management Service (AWS KMS) key is configured for an Amazon SageMaker endpoint configuration. The policy fails if 'KmsKeyId' is not specified for the Amazon SageMaker endpoint configuration.

The policy evaluates `aws_sagemaker_endpoint_configuration` resources.

This rule is covered by the [sagemaker-endpoint-configuration-kms-key-configured](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/sagemaker/sagemaker-endpoint-configuration-kms-key-configured.policy.hcl) policy.

## Policy Results

```bash
trace:
      #
      sagemaker-endpoint-configuration-kms-key-configured.policytest.hcl...
      running
      #
      resource.aws_sagemaker_endpoint_configuration.pass_kms_key_set...
      running
      #
      resource.aws_sagemaker_endpoint_configuration.pass_kms_key_set...
      pass
      #
      resource.aws_sagemaker_endpoint_configuration.fail_kms_key_missing...
      running
      #
      resource.aws_sagemaker_endpoint_configuration.fail_kms_key_missing...
      pass
      #
      resource.aws_sagemaker_endpoint_configuration.fail_kms_key_empty...
      running
      #
      resource.aws_sagemaker_endpoint_configuration.fail_kms_key_empty...
      pass
      #
      resource.aws_sagemaker_endpoint_configuration.fail_kms_key_null...
      running
      #
      resource.aws_sagemaker_endpoint_configuration.fail_kms_key_null...
      pass
      #
      resource.aws_sagemaker_endpoint_configuration.pass_kms_key_in_allowlist_f2...
      running
      #
      resource.aws_sagemaker_endpoint_configuration.pass_kms_key_in_allowlist_f2...
      pass
      #
      resource.aws_sagemaker_endpoint_configuration.fail_kms_key_missing_with_allowlist_f2...
      running
      #
      resource.aws_sagemaker_endpoint_configuration.fail_kms_key_missing_with_allowlist_f2...
      pass
      #
      sagemaker-endpoint-configuration-kms-key-configured.policytest.hcl...
      pass
```

---
