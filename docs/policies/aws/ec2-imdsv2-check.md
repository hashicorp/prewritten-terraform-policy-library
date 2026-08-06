# EC2 instances should use Instance Metadata Service Version 2 (IMDSv2)

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Network Security |

## Description

This control checks whether your EC2 instance metadata version is configured with Instance Metadata Service Version 2 (IMDSv2). The control passes if HttpTokens is set to required for IMDSv2. The control fails if HttpTokens is set to optional.

You use instance metadata to configure or manage the running instance. The IMDS provides access to temporary, frequently rotated credentials. These credentials remove the need to hard code or distribute sensitive credentials to instances manually or programmatically. The IMDS is attached locally to every EC2 instance. It runs on a special "link local" IP address of 169.254.169.254. This IP address is only accessible by software that runs on the instance.

Version 2 of the IMDS adds new protections for the following types of vulnerabilities. These vulnerabilities could be used to try to access the IMDS.

Open Layer 3 firewalls and network address translation (NAT)

Security Hub CSPM recommends that you configure your EC2 instances with IMDSv2.

This rule is covered by the [ec2-imdsv2-check](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/ec2/ec2-imdsv2-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ec2-imdsv2-check.policytest.hcl... running
      # resource.aws_ec2_instance_metadata_defaults.imds_v2_enabled... running
      # resource.aws_ec2_instance_metadata_defaults.imds_v2_enabled... pass
      # resource.aws_ec2_instance_metadata_defaults.imds_v2_disabled... running
      # resource.aws_ec2_instance_metadata_defaults.imds_v2_disabled... pass
      # resource.aws_ec2_instance_metadata_defaults.imds_v2_undefined... running
      # resource.aws_ec2_instance_metadata_defaults.imds_v2_undefined... pass
      # ec2-imdsv2-check.policytest.hcl... pass
```

---
