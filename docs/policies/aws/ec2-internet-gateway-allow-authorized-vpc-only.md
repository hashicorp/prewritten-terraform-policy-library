# Internet gateways should be attached only to authorized VPCs

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure network configuration |

## Description

This policy implements the AWS Config rule [internet-gateway-authorized-vpc-only](https://docs.aws.amazon.com/config/latest/developerguide/internet-gateway-authorized-vpc-only.html), which is part of the ISO/IEC 27001:2013 Annex A framework in AWS Audit Manager. Checks if internet gateways are attached to an authorized virtual private cloud (Amazon VPC). The rule is NON_COMPLIANT if internet gateways are attached to an unauthorized VPC.

The policy evaluates `aws_internet_gateway`, `aws_internet_gateway_attachment` resources.

This rule is covered by the [ec2-internet-gateway-allow-authorized-vpc-only](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/ec2/ec2-internet-gateway-allow-authorized-vpc-only.policy.hcl) policy.

## Policy Results

```bash
trace:
      #
      ec2-internet-gateway-allow-authorized-vpc-only.policytest.hcl...
      running
      # resource.aws_internet_gateway.pass_igw_no_vpc_id...
      running
      # resource.aws_internet_gateway.pass_igw_no_vpc_id...
      pass
      #
      resource.aws_internet_gateway.fail_igw_no_authorized_list...
      running
      #
      resource.aws_internet_gateway.fail_igw_no_authorized_list...
      pass
      #
      resource.aws_internet_gateway_attachment.fail_attachment_no_authorized_list...
      running
      #
      resource.aws_internet_gateway_attachment.fail_attachment_no_authorized_list...
      pass
      #
      resource.aws_internet_gateway.fail_igw_unauthorized_vpc_f2...
      running
      #
      resource.aws_internet_gateway.fail_igw_unauthorized_vpc_f2...
      pass
      #
      resource.aws_internet_gateway.fail_igw_empty_vpc_id_f2...
      running
      #
      resource.aws_internet_gateway.fail_igw_empty_vpc_id_f2...
      pass
      #
      resource.aws_internet_gateway_attachment.fail_attachment_unauthorized_vpc_f2...
      running
      #
      resource.aws_internet_gateway_attachment.fail_attachment_unauthorized_vpc_f2...
      pass
      #
      ec2-internet-gateway-allow-authorized-vpc-only.policytest.hcl...
      pass
```

---
