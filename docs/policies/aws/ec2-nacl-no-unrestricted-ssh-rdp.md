# Network ACLs should not allow ingress from 0.0.0.0/0 to port 22 or port 3389

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure Network Configuration |

## Description

This control checks whether a network access control list (network ACL) allows unrestricted access to the default TCP ports for SSH/RDP ingress traffic. The control fails if the network ACL inbound entry allows a source CIDR block of '0.0.0.0/0' or '::/0' for TCP ports 22 or 3389. The control doesn't generate findings for a default network ACL.

Access to remote server administration ports, such as port 22 (SSH) and port 3389 (RDP), should not be publicly accessible, as this may allow unintended access to resources within your VPC.

This rule is covered by the [ec2-nacl-no-unrestricted-ssh-rdp](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/ec2/ec2-nacl-no-unrestricted-ssh-rdp.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ec2-nacl-no-unrestricted-ssh-rdp.policytest.hcl... running
      # resource.aws_network_acl.pass_restricted_ssh... running
      # resource.aws_network_acl.pass_restricted_ssh... pass
      # resource.aws_network_acl.pass_restricted_rdp... running
      # resource.aws_network_acl.pass_restricted_rdp... pass
      # resource.aws_network_acl.fail_unrestricted_ssh_ipv4... running
      # resource.aws_network_acl.fail_unrestricted_ssh_ipv4... pass
      # resource.aws_network_acl.fail_unrestricted_rdp_ipv4... running
      # resource.aws_network_acl.fail_unrestricted_rdp_ipv4... pass
      # resource.aws_network_acl.fail_unrestricted_ssh_ipv6... running
      # resource.aws_network_acl.fail_unrestricted_ssh_ipv6... pass
      # resource.aws_network_acl.fail_unrestricted_rdp_ipv6... running
      # resource.aws_network_acl.fail_unrestricted_rdp_ipv6... pass
      # resource.aws_network_acl.pass_deny_ssh... running
      # resource.aws_network_acl.pass_deny_ssh... pass
      # resource.aws_network_acl.fail_port_range_ssh... running
      # resource.aws_network_acl.fail_port_range_ssh... pass
      # resource.aws_network_acl.fail_port_range_rdp... running
      # resource.aws_network_acl.fail_port_range_rdp... pass
      # resource.aws_network_acl_rule.pass_rule_restricted_ssh... running
      # resource.aws_network_acl_rule.pass_rule_restricted_ssh... pass
      # resource.aws_network_acl_rule.fail_rule_unrestricted_ssh... running
      # resource.aws_network_acl_rule.fail_rule_unrestricted_ssh... pass
      # resource.aws_network_acl_rule.fail_rule_unrestricted_rdp... running
      # resource.aws_network_acl_rule.fail_rule_unrestricted_rdp... pass
      # resource.aws_network_acl_rule.pass_rule_egress... running
      # resource.aws_network_acl_rule.pass_rule_egress... pass
      # resource.aws_network_acl.pass_no_ingress... running
      # resource.aws_network_acl.pass_no_ingress... pass
      # resource.aws_network_acl.fail_unrestricted_ssh_udp... running
      # resource.aws_network_acl.fail_unrestricted_ssh_udp... pass
      # resource.aws_network_acl.fail_unrestricted_rdp_udp... running
      # resource.aws_network_acl.fail_unrestricted_rdp_udp... pass
      # resource.aws_network_acl.fail_unrestricted_ssh_all_protocols... running
      # resource.aws_network_acl.fail_unrestricted_ssh_all_protocols... pass
      # resource.aws_network_acl.fail_unrestricted_rdp_all_protocols... running
      # resource.aws_network_acl.fail_unrestricted_rdp_all_protocols... pass
      # resource.aws_network_acl_rule.fail_rule_unrestricted_ssh_udp... running
      # resource.aws_network_acl_rule.fail_rule_unrestricted_ssh_udp... pass
      # resource.aws_network_acl_rule.fail_rule_unrestricted_rdp_udp... running
      # resource.aws_network_acl_rule.fail_rule_unrestricted_rdp_udp... pass
      # resource.aws_network_acl_rule.fail_rule_unrestricted_ssh_ipv6... running
      # resource.aws_network_acl_rule.fail_rule_unrestricted_ssh_ipv6... pass
      # resource.aws_network_acl_rule.fail_rule_unrestricted_rdp_ipv6... running
      # resource.aws_network_acl_rule.fail_rule_unrestricted_rdp_ipv6... pass
      # resource.aws_network_acl_rule.pass_rule_deny_ssh... running
      # resource.aws_network_acl_rule.pass_rule_deny_ssh... pass
      # resource.aws_network_acl_rule.fail_rule_port_range_ssh... running
      # resource.aws_network_acl_rule.fail_rule_port_range_ssh... pass
      # resource.aws_network_acl_rule.fail_rule_port_range_rdp... running
      # resource.aws_network_acl_rule.fail_rule_port_range_rdp... pass
      # ec2-nacl-no-unrestricted-ssh-rdp.policytest.hcl... pass
```

---
