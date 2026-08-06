# Unused Network Access Control Lists should be removed

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Network Security |

## Description

This control checks whether there are any unused network access control lists (network ACLs) in your virtual private cloud (VPC). The control fails if the network ACL isn't associated with a subnet. The control doesn't generate findings for an unused default network ACL.

The control checks the item configuration of the resource AWS::EC2::NetworkAcl and determines the relationships of the network ACL.

If the only relationship is the VPC of the network ACL, the control fails.

If other relationships are listed, then the control passes.

This rule is covered by the [vpc-network-acl-unused-check](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/ec2/vpc-network-acl-unused-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # vpc-network-acl-unused-check.policytest.hcl...
      running
      # resource.aws_network_acl.pass_direct_subnet_associations...
      running
      # resource.aws_network_acl.pass_direct_subnet_associations...
      pass
      # resource.aws_network_acl.fail_no_associations...
      running
      # resource.aws_network_acl.fail_no_associations...
      pass
      # resource.aws_network_acl.fail_empty_subnet_ids...
      running
      # resource.aws_network_acl.fail_empty_subnet_ids...
      pass
      # resource.aws_default_network_acl.pass_default_no_associations...
      running
      # resource.aws_default_network_acl.pass_default_no_associations...
      pass
      # resource.aws_default_network_acl.pass_default_with_associations...
      running
      # resource.aws_default_network_acl.pass_default_with_associations...
      pass
      # resource.aws_network_acl.pass_multiple_subnets...
      running
      # resource.aws_network_acl.pass_multiple_subnets...
      pass
      # resource.aws_network_acl.pass_single_subnet...
      running
      # resource.aws_network_acl.pass_single_subnet...
      pass
      # vpc-network-acl-unused-check.policytest.hcl...
      pass
```

---
