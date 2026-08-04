# Amazon EC2 Transit Gateways should not automatically accept VPC attachment requests

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure network configuration |

## Description

This control checks if EC2 transit gateways are automatically accepting shared VPC attachments. This control fails for a transit gateway that automatically accepts shared VPC attachment requests.

Turning on AutoAcceptSharedAttachments configures a transit gateway to automatically accept any cross-account VPC attachment requests without verifying the request or the account the attachment is originating from. To follow the best practices of authorization and authentication, we recommended turning off this feature to ensure that only authorized VPC attachment requests are accepted.

This rule is covered by the [ec2-transit-gateway-auto-vpc-attach-disabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/ec2/ec2-transit-gateway-auto-vpc-attach-disabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ec2-transit-gateway-auto-vpc-attach-disabled.policytest.hcl...
      running
      # resource.aws_ec2_transit_gateway.compliant_explicit...
      running
      # resource.aws_ec2_transit_gateway.compliant_explicit...
      pass
      # resource.aws_ec2_transit_gateway.compliant_default...
      running
      # resource.aws_ec2_transit_gateway.compliant_default...
      pass
      # resource.aws_ec2_transit_gateway.non_compliant...
      running
      # resource.aws_ec2_transit_gateway.non_compliant...
      pass
      # ec2-transit-gateway-auto-vpc-attach-disabled.policytest.hcl...
      pass
```

---
