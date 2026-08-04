# EC2 network interfaces should have source/destination checking enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Network Security |

## Description

This control checks whether source/destination checking is enabled for an Amazon EC2 elastic network interface (ENI) that's managed by users. The control fails if source/destination checking is disabled for the user-managed ENI. This control checks only the following types of ENIs: aws_codestar_connections_managed, branch, efa, interface, lambda, and quicksight.

Source/destination checking for Amazon EC2 instances and attached ENIs should be enabled and configured consistently across your EC2 instances. Each ENI has its own setting for source/destination checks. If source/destination checking is enabled, Amazon EC2 enforces source/destination address validation, which ensures that an instance is either the source or the destination of any traffic that it receives. This provides an additional layer of network security by preventing resources from handling unintended traffic and preventing IP address spoofing.

If you're using an EC2 instance as a NAT instance and you disabled source/destination checking for its ENI, you can use a NAT gateway instead.

This rule is covered by the [ec2-enis-source-destination-check-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/ec2/ec2-enis-source-destination-check-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ec2-enis-source-destination-check-enabled.policytest.hcl...
      running
      # resource.aws_network_interface.compliant_interface...
      running
      # resource.aws_network_interface.compliant_interface...
      pass
      # resource.aws_network_interface.efa_default...
      running
      # resource.aws_network_interface.efa_default...
      pass
      # resource.aws_network_interface.non_compliant_lambda...
      running
      # resource.aws_network_interface.non_compliant_lambda...
      pass
      # resource.aws_network_interface.branch_compliant...
      running
      # resource.aws_network_interface.branch_compliant...
      pass
      # resource.aws_network_interface.quicksight_non_compliant...
      running
      # resource.aws_network_interface.quicksight_non_compliant...
      pass
      # resource.aws_network_interface.nat_gateway_filtered...
      running
      # resource.aws_network_interface.nat_gateway_filtered...
      pass
      # resource.aws_network_interface.codestar_compliant...
      running
      # resource.aws_network_interface.codestar_compliant...
      pass
      # ec2-enis-source-destination-check-enabled.policytest.hcl...
      pass
```

---
