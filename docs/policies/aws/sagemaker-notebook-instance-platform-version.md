# SageMaker notebook instances should run on supported platforms

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Vulnerability, patch, and version management |

## Description

This control checks whether an Amazon SageMaker AI notebook instance is configured to run on a supported platform, based on the platform identifier specified for the notebook instance. The control fails if the notebook instance is configured to run on a platform that's no longer supported.

If the platform for an Amazon SageMaker AI notebook instance is no longer supported, it might not receive security patches, bug fixes, or other types of updates. Notebook instances might continue to function, but they won't receive SageMaker AI security updates or critical bug fixes. You assume the risks associated with using an unsupported platform. For more information, see JupyterLab versioning in the Amazon SageMaker AI Developer Guide.

This rule is covered by the [sagemaker-notebook-instance-platform-version](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/sagemaker/sagemaker-notebook-instance-platform-version.policy.hcl) policy.

## Policy Results

```bash
trace:
      # sagemaker-notebook-instance-platform-version.policytest.hcl... running
      # resource.aws_sagemaker_notebook_instance.pass_explicit_supported_platform... running
      # resource.aws_sagemaker_notebook_instance.pass_explicit_supported_platform... pass
      # resource.aws_sagemaker_notebook_instance.pass_default_platform... running
      # resource.aws_sagemaker_notebook_instance.pass_default_platform... pass
      # resource.aws_sagemaker_notebook_instance.fail_deprecated_al1_v1... running
      # resource.aws_sagemaker_notebook_instance.fail_deprecated_al1_v1... pass
      # resource.aws_sagemaker_notebook_instance.fail_deprecated_al2_v1... running
      # resource.aws_sagemaker_notebook_instance.fail_deprecated_al2_v1... pass
      # resource.aws_sagemaker_notebook_instance.fail_deprecated_al2_v2... running
      # resource.aws_sagemaker_notebook_instance.fail_deprecated_al2_v2... pass
      # sagemaker-notebook-instance-platform-version.policytest.hcl... pass
```

---
