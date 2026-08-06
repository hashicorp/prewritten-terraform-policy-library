# SageMaker models should have network isolation enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resources not publicly accessible |

## Description

This control checks whether an Amazon SageMaker AI hosted model has network isolation enabled. The control fails if the EnableNetworkIsolation parameter for the hosted model is set to False.

SageMaker AI training and deployed inference containers are internet-enabled by default. If you don't want SageMaker AI to provide external network access to your training or inference containers, you can enable network isolation. If you enable network isolation, no inbound or outbound network calls can be made to or from the model container, including calls to or from other AWS services. Additionally, no AWS credentials are made available to the container runtime environment. Enabling network isolation helps prevent unintended access to your SageMaker AI resources from the internet.

On August 13, 2025, Security Hub CSPM changed the title and description of this control. The new title and description more accurately reflect that the control checks the setting for the EnableNetworkIsolation parameter of Amazon SageMaker AI hosted models. Previously, the title of this control was: SageMaker models should block inbound traffic.

This rule is covered by the [sagemaker-model-isolation-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/sagemaker/sagemaker-model-isolation-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # sagemaker-model-isolation-enabled.policytest.hcl... running
      # resource.aws_sagemaker_model.pass_with_isolation_enabled... running
      # resource.aws_sagemaker_model.pass_with_isolation_enabled... pass
      # resource.aws_sagemaker_model.fail_with_isolation_disabled... running
      # resource.aws_sagemaker_model.fail_with_isolation_disabled... pass
      # resource.aws_sagemaker_model.fail_without_isolation_specified... running
      # resource.aws_sagemaker_model.fail_without_isolation_specified... pass
      # sagemaker-model-isolation-enabled.policytest.hcl... pass
```

---
