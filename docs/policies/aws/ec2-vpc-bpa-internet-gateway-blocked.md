# EC2 VPC Block Public Access settings should block internet gateway traffic

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resources not publicly accessible |

## Description

This control checks whether Amazon EC2 VPC Block Public Access (BPA) settings are configured to block internet gateway traffic for all Amazon VPCs in the AWS account. The control fails if VPC BPA settings aren't configured to block internet gateway traffic. For the control to pass, the VPC BPA InternetGatewayBlockMode must be set to block-bidirectional or block-ingress. If the parameter vpcBpaInternetGatewayBlockMode is provided, the control passes only if the VPC BPA value for InternetGatewayBlockMode matches the parameter.

Configuring the VPC BPA settings for your account in an AWS Region lets you block resources in VPCs and subnets that you own in that Region from reaching or being reached from the internet through internet gateways and egress-only internet gateways. If you need specific VPCs and subnets to be able to reach or be reachable from the internet, you can exclude them by configuring VPC BPA exclusions. For instructions on creating and deleting exclusions, see Create and delete exclusions in the Amazon VPC User Guide.

This rule is covered by the [ec2-vpc-bpa-internet-gateway-blocked](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/ec2/ec2-vpc-bpa-internet-gateway-blocked.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ec2-vpc-bpa-internet-gateway-blocked.policytest.hcl...
      running
      # resource.aws_vpc_block_public_access_options.compliant_bidirectional...
      running
      # resource.aws_vpc_block_public_access_options.compliant_bidirectional...
      pass
      # resource.aws_vpc_block_public_access_options.compliant_ingress...
      running
      # resource.aws_vpc_block_public_access_options.compliant_ingress...
      pass
      # resource.aws_vpc_block_public_access_options.non_compliant_off...
      running
      # resource.aws_vpc_block_public_access_options.non_compliant_off...
      pass
      # resource.aws_vpc_block_public_access_options.non_compliant_missing...
      running
      # resource.aws_vpc_block_public_access_options.non_compliant_missing...
      pass
      # ec2-vpc-bpa-internet-gateway-blocked.policytest.hcl...
      pass
```

---
