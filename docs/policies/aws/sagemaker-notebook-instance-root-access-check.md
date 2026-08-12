# Users should not have root access to SageMaker notebook instances

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Root user access restrictions |

## Description

This control checks whether root access is turned on for an Amazon SageMaker AI notebook instance. The control fails if root access is turned on for a SageMaker AI notebook instance.

In adherence to the principal of least privilege, it is a recommended security best practice to restrict root access to instance resources to avoid unintentionally over provisioning permissions.

This rule is covered by the [sagemaker-notebook-instance-root-access-check](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/sagemaker/sagemaker-notebook-instance-root-access-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # sagemaker-notebook-instance-root-access-check.policytest.hcl... running
      # resource.aws_sagemaker_notebook_instance.pass_root_access_disabled... running
      # resource.aws_sagemaker_notebook_instance.pass_root_access_disabled... pass
      # resource.aws_sagemaker_notebook_instance.fail_root_access_enabled... running
      # resource.aws_sagemaker_notebook_instance.fail_root_access_enabled... pass
      # resource.aws_sagemaker_notebook_instance.fail_root_access_not_specified... running
      # resource.aws_sagemaker_notebook_instance.fail_root_access_not_specified... pass
      # sagemaker-notebook-instance-root-access-check.policytest.hcl... pass
```

---
