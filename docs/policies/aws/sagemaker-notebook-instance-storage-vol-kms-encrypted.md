# SageMaker notebook instances should be encrypted with customer managed AWS KMS keys

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks whether a SageMaker AI notebook instance is configured with an AWS KMS key for storage volume encryption. The control fails if a KMS key is not configured for the notebook instance.

The policy evaluates each `aws_sagemaker_notebook_instance` resource and requires a non-empty `kms_key_id`. A Terraform plan cannot tell whether the key is customer managed, so any configured key passes, matching the control's check.

This rule is covered by the [sagemaker-notebook-instance-storage-vol-kms-encrypted](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/sagemaker/sagemaker-notebook-instance-storage-vol-kms-encrypted.policy.hcl) policy.

## Policy Results

```bash
trace:
      # sagemaker-notebook-instance-storage-vol-kms-encrypted.policytest.hcl...
      running
      # resource.aws_sagemaker_notebook_instance.pass_kms_key_arn...
      running
      # resource.aws_sagemaker_notebook_instance.pass_kms_key_arn...
      pass
      # resource.aws_sagemaker_notebook_instance.pass_kms_key_id...
      running
      # resource.aws_sagemaker_notebook_instance.pass_kms_key_id...
      pass
      # resource.aws_sagemaker_notebook_instance.fail_kms_key_omitted...
      running
      # resource.aws_sagemaker_notebook_instance.fail_kms_key_omitted...
      pass
      # resource.aws_sagemaker_notebook_instance.fail_kms_key_null...
      running
      # resource.aws_sagemaker_notebook_instance.fail_kms_key_null...
      pass
      # resource.aws_sagemaker_notebook_instance.fail_kms_key_empty...
      running
      # resource.aws_sagemaker_notebook_instance.fail_kms_key_empty...
      pass
      # sagemaker-notebook-instance-storage-vol-kms-encrypted.policytest.hcl...
      pass
```

---
