# EBS default encryption should be enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks whether account-level encryption is enabled by default for Amazon Elastic Block Store (Amazon EBS) volumes. The control fails if the account level encryption isn't enabled for EBS volumes.

When encryption is enabled for your account, Amazon EBS volumes and snapshot copies are encrypted at rest. This adds an additional layer of protection for your data. For more information, see Encryption by default in the Amazon EC2 User Guide.

This rule is covered by the [ec2-ebs-encryption-by-default](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/ec2/ec2-ebs-encryption-by-default.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ec2-ebs-encryption-by-default.policytest.hcl... running
      # resource.aws_ebs_encryption_by_default.enabled_true... running
      # resource.aws_ebs_encryption_by_default.enabled_true... pass
      # resource.aws_ebs_encryption_by_default.enabled_false... running
      # resource.aws_ebs_encryption_by_default.enabled_false... pass
      # resource.aws_ebs_encryption_by_default.no_enabled_attr... running
      # resource.aws_ebs_encryption_by_default.no_enabled_attr... pass
      # ec2-ebs-encryption-by-default.policytest.hcl... pass
```

---
