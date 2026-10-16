# Internet gateways should be attached only to authorized VPCs

| Provider | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure network configuration |

## Description

This policy checks if internet gateways are attached to an authorized virtual private cloud (Amazon VPC). The policy fails if internet gateways are attached to an unauthorized VPC.

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
