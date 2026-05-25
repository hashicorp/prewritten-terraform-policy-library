# EC2 launch templates should use Instance Metadata Service Version 2 (IMDSv2)

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Network Security |

## Description

This control checks whether an Amazon EC2 launch template is configured with Instance Metadata Service Version 2 (IMDSv2). The control fails if HttpTokens is set to optional.

Running resources on supported software versions ensures optimal performance, security, and access to the latest features. Regular updates safeguard against vulnerabilities, which help ensure a stable and efficient user experience.

This rule is covered by the [ec2-launch-template-imdsv2-check](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/ec2/ec2-launch-template-imdsv2-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ec2-launch-template-imdsv2-check.policytest.hcl... running
      # resource.aws_launch_template.pass_http_tokens_required... running
      # resource.aws_launch_template.pass_http_tokens_required... pass
      # resource.aws_launch_template.pass_complete_metadata_options... running
      # resource.aws_launch_template.pass_complete_metadata_options... pass
      # resource.aws_launch_template.fail_http_tokens_optional... running
      # resource.aws_launch_template.fail_http_tokens_optional... pass
      # resource.aws_launch_template.fail_http_tokens_not_specified... running
      # resource.aws_launch_template.fail_http_tokens_not_specified... pass
      # resource.aws_launch_template.fail_no_metadata_options... running
      # resource.aws_launch_template.fail_no_metadata_options... pass
      # ec2-launch-template-imdsv2-check.policytest.hcl... pass
```

---
