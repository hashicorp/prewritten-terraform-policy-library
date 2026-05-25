# Amazon EMR block public access setting should be enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resource not publicly accessible |

## Description

This control checks whether your account is configured with Amazon EMR block public access. The control fails if the block public access setting isn't enabled or if any port other than port 22 is allowed.

Amazon EMR block public access prevents you from launching a cluster in a public subnet if the cluster has a security configuration that allows inbound traffic from public IP addresses on a port. When a user from your AWS account launches a cluster, Amazon EMR checks the port rules in the security group for the cluster and compares them with your inbound traffic rules. If the security group has an inbound rule that opens ports to the public IP addresses IPv4 0.0.0.0/0 or IPv6 ::/0, and those ports aren't specified as exceptions for your account, Amazon EMR doesn't let the user create the cluster.

Block public access is enabled by default. To increase account protection, we recommend that you keep it enabled.

This rule is covered by the [emr-block-public-access](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/emr/emr-block-public-access.policy.hcl) policy.

## Policy Results

```bash
trace:
      # emr-block-public-access.policytest.hcl... running
      # resource.aws_emr_block_public_access_configuration.pass_block_enabled_ssh_only... running
      # resource.aws_emr_block_public_access_configuration.pass_block_enabled_ssh_only... pass
      # resource.aws_emr_block_public_access_configuration.pass_default_block_ssh_only... running
      # resource.aws_emr_block_public_access_configuration.pass_default_block_ssh_only... pass
      # resource.aws_emr_block_public_access_configuration.fail_block_disabled... running
      # resource.aws_emr_block_public_access_configuration.fail_block_disabled... pass
      # resource.aws_emr_block_public_access_configuration.fail_wrong_min_range... running
      # resource.aws_emr_block_public_access_configuration.fail_wrong_min_range... pass
      # resource.aws_emr_block_public_access_configuration.fail_wrong_max_range... running
      # resource.aws_emr_block_public_access_configuration.fail_wrong_max_range... pass
      # resource.aws_emr_block_public_access_configuration.fail_all_ports... running
      # resource.aws_emr_block_public_access_configuration.fail_all_ports... pass
      # resource.aws_emr_block_public_access_configuration.fail_missing_range... running
      # resource.aws_emr_block_public_access_configuration.fail_missing_range... pass
      # resource.aws_emr_block_public_access_configuration.fail_only_min_range... running
      # resource.aws_emr_block_public_access_configuration.fail_only_min_range... pass
      # resource.aws_emr_block_public_access_configuration.fail_only_max_range... running
      # resource.aws_emr_block_public_access_configuration.fail_only_max_range... pass
      # emr-block-public-access.policytest.hcl... pass
```

---
