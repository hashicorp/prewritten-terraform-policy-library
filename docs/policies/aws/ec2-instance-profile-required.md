# EC2 instances should have an IAM instance profile attached

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure access management |

## Description

This policy implements the AWS Config rule [ec2-instance-profile-attached](https://docs.aws.amazon.com/config/latest/developerguide/ec2-instance-profile-attached.html), which is part of the ISO/IEC 27001:2013 Annex A framework in AWS Audit Manager. Checks if an EC2 instance has an AWS Identity and Access Management (IAM) profile attached to it. The rule is NON_COMPLIANT if no IAM profile is attached to the EC2 instance.

The policy evaluates `aws_instance` resources.

This rule is covered by the [ec2-instance-profile-required](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/ec2/ec2-instance-profile-required.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ec2-instance-profile-required.policytest.hcl...
      running
      # resource.aws_instance.pass_profile_set_no_allowlist...
      running
      # resource.aws_instance.pass_profile_set_no_allowlist...
      pass
      # resource.aws_instance.fail_profile_missing...
      running
      # resource.aws_instance.fail_profile_missing...
      pass
      # resource.aws_instance.fail_profile_empty...
      running
      # resource.aws_instance.fail_profile_empty...
      pass
      #
      resource.aws_instance.pass_profile_in_allowlist_exact_f2...
      running
      #
      resource.aws_instance.pass_profile_in_allowlist_exact_f2...
      pass
      #
      resource.aws_instance.pass_profile_matches_arn_derived_name_f2...
      running
      #
      resource.aws_instance.pass_profile_matches_arn_derived_name_f2...
      pass
      #
      resource.aws_instance.fail_profile_missing_with_allowlist_f2...
      running
      #
      resource.aws_instance.fail_profile_missing_with_allowlist_f2...
      pass
      # ec2-instance-profile-required.policytest.hcl...
      pass
```

---
