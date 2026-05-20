# Amazon SageMaker notebook instances should not have direct internet access

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure network configuration |

## Description

This control checks whether direct internet access is disabled for an SageMaker AI notebook instance. The control fails if the DirectInternetAccess field is enabled for the notebook instance.

If you configure your SageMaker AI instance without a VPC, then by default direct internet access is enabled on your instance. You should configure your instance with a VPC and change the default setting to Disable—Access the internet through a VPC. To train or host models from a notebook, you need internet access. To enable internet access, your VPC must have either an interface endpoint (AWS PrivateLink) or a NAT gateway and a security group that allows outbound connections. To learn more about how to connect a notebook instance to resources in a VPC, see Connect a notebook instance to resources in a VPC in the Amazon SageMaker AI Developer Guide. You should also ensure that access to your SageMaker AI configuration is limited to only authorized users. Restrict IAM permissions that permit users to change SageMaker AI settings and resources.

This rule is covered by the [sagemaker-notebook-no-direct-internet-access](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/sagemaker/sagemaker-notebook-no-direct-internet-access.policy.hcl) policy.

## Policy Results

```bash
trace:
      # sagemaker-notebook-no-direct-internet-access.policytest.hcl... running
      # resource.aws_sagemaker_notebook_instance.compliant... running
      # resource.aws_sagemaker_notebook_instance.compliant... pass
      # resource.aws_sagemaker_notebook_instance.non_compliant_enabled... running
      # resource.aws_sagemaker_notebook_instance.non_compliant_enabled... pass
      # resource.aws_sagemaker_notebook_instance.non_compliant_default... running
      # resource.aws_sagemaker_notebook_instance.non_compliant_default... pass
      # resource.aws_sagemaker_notebook_instance.missing_subnet... running
      # resource.aws_sagemaker_notebook_instance.missing_subnet... pass
      # resource.aws_sagemaker_notebook_instance.missing_sg... running
      # resource.aws_sagemaker_notebook_instance.missing_sg... pass
      # resource.aws_sagemaker_notebook_instance.empty_sg... running
      # resource.aws_sagemaker_notebook_instance.empty_sg... pass
      # sagemaker-notebook-no-direct-internet-access.policytest.hcl... pass
```

---
