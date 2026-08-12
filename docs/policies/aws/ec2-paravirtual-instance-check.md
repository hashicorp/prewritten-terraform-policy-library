# Amazon EC2 paravirtual instance types should not be used

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Vulnerability, patch, and version management |

## Description

This control checks whether the virtualization type of an EC2 instance is paravirtual. The control fails if the virtualizationType of the EC2 instance is set to paravirtual.

Linux Amazon Machine Images (AMIs) use one of two types of virtualization: paravirtual (PV) or hardware virtual machine (HVM). The main differences between PV and HVM AMIs are the way in which they boot and whether they can take advantage of special hardware extensions (CPU, network, and storage) for better performance.

Historically, PV guests had better performance than HVM guests in many cases, but because of enhancements in HVM virtualization and the availability of PV drivers for HVM AMIs, this is no longer true. For more information, see Linux AMI virtualization types in the Amazon EC2 User Guide.

This rule is covered by the [ec2-paravirtual-instance-check](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/ec2/ec2-paravirtual-instance-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ec2-paravirtual-instance-check.policytest.hcl...
      running
      # resource.aws_instance.hvm_instance...
      running
      # resource.aws_instance.hvm_instance...
      pass
      # resource.aws_instance.paravirtual_instance...
      running
      # resource.aws_instance.paravirtual_instance...
      pass
      # resource.aws_instance.unknown_ami_instance...
      running
      # resource.aws_instance.unknown_ami_instance...
      pass
      # resource.aws_instance.hvm_instance_2...
      running
      # resource.aws_instance.hvm_instance_2...
      pass
      # ec2-paravirtual-instance-check.policytest.hcl...
      pass
```

---
