# Ensure IAM instance roles are used for AWS resource access from instances

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure access management |

## Description

This control checks whether EC2 instances are launched with an IAM instance profile.

An instance that needs to call AWS APIs must get credentials from somewhere. Without an instance profile, the usual alternative is a long-lived access key baked into user data, an AMI, or a configuration file — credentials that do not rotate, that survive the instance, and that are trivially recoverable by anyone who can read the disk or the metadata.

Instance profiles supply short-lived credentials through the instance metadata service and rotate them automatically. The policy requires every EC2 instance to set a non-empty `iam_instance_profile`.

This rule is covered by the [iam-instance-role](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/ec2/iam-instance-role.policy.hcl) policy.

## Policy Results

```bash
trace:
      # iam-instance-role.policytest.hcl... running
      # resource.aws_instance.with_iam_instance_profile... running
      # resource.aws_instance.with_iam_instance_profile... pass
      # resource.aws_instance.missing_iam_instance_profile... running
      # resource.aws_instance.missing_iam_instance_profile... pass
      # resource.aws_instance.null_iam_instance_profile... running
      # resource.aws_instance.null_iam_instance_profile... pass
      # resource.aws_instance.empty_iam_instance_profile... running
      # resource.aws_instance.empty_iam_instance_profile... pass
      # iam-instance-role.policytest.hcl... pass
```

---
