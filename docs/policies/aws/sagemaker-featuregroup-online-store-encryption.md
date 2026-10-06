# SageMaker feature group online stores with standard storage should be encrypted with AWS KMS keys

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks whether an Amazon SageMaker online store for a feature group with standard storage is encrypted at rest with an AWS KMS key. The control fails if KMS key encryption is not configured for the online store.

Using customer-managed AWS KMS keys for encryption at rest of SageMaker feature group online stores provides enhanced security. Customer-managed KMS keys give you full control over encryption key lifecycle and key policies. Additionally, all encryption key usage can be logged and monitored through AWS CloudTrail for auditability.

This rule is covered by the [sagemaker-featuregroup-online-store-encryption](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/sagemaker/sagemaker-featuregroup-online-store-encryption.policy.hcl) policy.

## Policy Results

```bash
trace:
      # sagemaker-featuregroup-online-store-encryption.policytest.hcl... running
      # resource.aws_sagemaker_feature_group.pass_kms_key_set... running
      # resource.aws_sagemaker_feature_group.pass_kms_key_set... pass
      # resource.aws_sagemaker_feature_group.fail_kms_key_empty_string... running
      # resource.aws_sagemaker_feature_group.fail_kms_key_empty_string... pass
      # resource.aws_sagemaker_feature_group.fail_kms_key_absent... running
      # resource.aws_sagemaker_feature_group.fail_kms_key_absent... pass
      # resource.aws_sagemaker_feature_group.fail_kms_key_null... running
      # resource.aws_sagemaker_feature_group.fail_kms_key_null... pass
      # resource.aws_sagemaker_feature_group.fail_security_config_empty... running
      # resource.aws_sagemaker_feature_group.fail_security_config_empty... pass
      # resource.aws_sagemaker_feature_group.fail_security_config_absent... running
      # resource.aws_sagemaker_feature_group.fail_security_config_absent... pass
      # resource.aws_sagemaker_feature_group.skip_no_online_store_config... running
      # resource.aws_sagemaker_feature_group.skip_no_online_store_config... pass
      # resource.aws_sagemaker_feature_group.skip_online_store_config_null... running
      # resource.aws_sagemaker_feature_group.skip_online_store_config_null... pass
      # resource.aws_sagemaker_feature_group.skip_glue_not_disabled... running
      # resource.aws_sagemaker_feature_group.skip_glue_not_disabled... pass
      # resource.aws_sagemaker_feature_group.skip_storage_type_inmemorystorage... running
      # resource.aws_sagemaker_feature_group.skip_storage_type_inmemorystorage... pass
      # sagemaker-featuregroup-online-store-encryption.policytest.hcl... pass
```

---