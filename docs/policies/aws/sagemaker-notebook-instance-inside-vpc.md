# SageMaker notebook instances should be launched in a custom VPC

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resources within VPC |

## Description

This control checks if an Amazon SageMaker AI notebook instance is launched within a custom virtual private cloud (VPC). This control fails if a SageMaker AI notebook instance is not launched within a custom VPC or if it is launched in the SageMaker AI service VPC.

Subnets are a range of IP addresses within a VPC. We recommend keeping your resources inside a custom VPC whenever possible to ensure secure network protection of your infrastructure. An Amazon VPC is a virtual network dedicated to your AWS account. With an Amazon VPC, you can control the network access and internet connectivity of your SageMaker AI Studio and notebook instances.

This rule is covered by the [sagemaker-notebook-instance-inside-vpc](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/sagemaker/sagemaker-notebook-instance-inside-vpc.policy.hcl) policy.

## Policy Results

```bash
trace:
      # sagemaker-notebook-instance-inside-vpc.policytest.hcl... running
      # resource.aws_sagemaker_notebook_instance.pass_with_subnet_id... running
      # resource.aws_sagemaker_notebook_instance.pass_with_subnet_id... pass
      # resource.aws_sagemaker_notebook_instance.fail_without_subnet_id... running
      # resource.aws_sagemaker_notebook_instance.fail_without_subnet_id... pass
      # resource.aws_sagemaker_notebook_instance.fail_with_null_subnet_id... running
      # resource.aws_sagemaker_notebook_instance.fail_with_null_subnet_id... pass
      # resource.aws_sagemaker_notebook_instance.fail_with_empty_subnet_id... running
      # resource.aws_sagemaker_notebook_instance.fail_with_empty_subnet_id... pass
      # sagemaker-notebook-instance-inside-vpc.policytest.hcl... pass
```

---
