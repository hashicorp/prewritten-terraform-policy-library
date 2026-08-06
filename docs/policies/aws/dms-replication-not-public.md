# Database Migration Service replication instances should not be public

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure network configuration |

## Description

This control checks whether AWS DMS replication instances are public. To do this, it examines the value of the PubliclyAccessible field.

A private replication instance has a private IP address that you cannot access outside of the replication network. A replication instance should have a private IP address when the source and target databases are in the same network. The network must also be connected to the replication instance's VPC using a VPN, Direct Connect, or VPC peering. To learn more about public and private replication instances, see Public and private replication instances in the AWS Database Migration Service User Guide.

You should also ensure that access to your AWS DMS instance configuration is limited to only authorized users. To do this, restrict users' IAM permissions to modify AWS DMS settings and resources.

This rule is covered by the [dms-replication-not-public](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/dms/dms-replication-not-public.policy.hcl) policy.

## Policy Results

```bash
trace:
      # dms-replication-not-public.policytest.hcl...
      running
      # resource.aws_dms_replication_instance.pass_explicit_false...
      running
      # resource.aws_dms_replication_instance.pass_explicit_false...
      pass
      # resource.aws_dms_replication_instance.pass_default_false...
      running
      # resource.aws_dms_replication_instance.pass_default_false...
      pass
      # resource.aws_dms_replication_instance.fail_public_instance...
      running
      # resource.aws_dms_replication_instance.fail_public_instance...
      pass
      # dms-replication-not-public.policytest.hcl...
      pass
```

---
