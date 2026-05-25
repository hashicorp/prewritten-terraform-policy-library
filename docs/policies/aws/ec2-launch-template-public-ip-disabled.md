# Amazon EC2 launch templates should not assign public IPs to network interfaces

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resources not publicly accessible |

## Description

This control checks if Amazon EC2 launch templates are configured to assign public IP addresses to network interfaces upon launch. The control fails if an EC2 launch template is configured to assign a public IP address to network interfaces or if there is at least one network interface that has a public IP address.

A public IP address is one that is reachable from the internet. If you configure your network interfaces with a public IP address, then the resources associated with those network interfaces may be reachable from the internet. EC2 resources shouldn't be publicly accessible because this may permit unintended access to your workloads.

This rule is covered by the [ec2-launch-template-public-ip-disabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/ec2/ec2-launch-template-public-ip-disabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ec2-launch-template-public-ip-disabled.policytest.hcl... running
      # resource.aws_launch_template.pass_no_network_interfaces... running
      # resource.aws_launch_template.pass_no_network_interfaces... pass
      # resource.aws_launch_template.pass_explicit_false... running
      # resource.aws_launch_template.pass_explicit_false... pass
      # resource.aws_launch_template.pass_unset_attribute... running
      # resource.aws_launch_template.pass_unset_attribute... pass
      # resource.aws_launch_template.fail_public_ip_enabled... running
      # resource.aws_launch_template.fail_public_ip_enabled... pass
      # resource.aws_launch_template.fail_multiple_interfaces_one_public... running
      # resource.aws_launch_template.fail_multiple_interfaces_one_public... pass
      # resource.aws_launch_template.pass_multiple_interfaces_all_false... running
      # resource.aws_launch_template.pass_multiple_interfaces_all_false... pass
      # ec2-launch-template-public-ip-disabled.policytest.hcl... pass
```

---
