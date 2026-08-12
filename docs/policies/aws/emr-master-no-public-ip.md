# Amazon EMR cluster primary nodes should not have public IP addresses

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure network configuration |


## Description

This control checks whether master nodes on Amazon EMR clusters have public IP addresses. The control fails if public IP addresses are associated with any of the master node instances.

Public IP addresses are designated in the `PublicIp` field of the `NetworkInterfaces` configuration for the instance. This control only checks Amazon EMR clusters that are in a `RUNNING` or `WAITING` state.

This rule is covered by the [emr-master-no-public-ip](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/emr/emr-master-no-public-ip.policy.hcl) policy.

## Policy Results

```bash
trace:
      # emr-master-no-public-ip.policytest.hcl...
      running
      # resource.aws_emr_cluster.pass_private_subnet_with_subnet_id...
      running
      # resource.aws_emr_cluster.pass_private_subnet_with_subnet_id...
      pass
      # resource.aws_emr_cluster.fail_public_subnet_with_subnet_id...
      running
      # resource.aws_emr_cluster.fail_public_subnet_with_subnet_id...
      pass
      # resource.aws_emr_cluster.fail_missing_subnet_config...
      running
      # resource.aws_emr_cluster.fail_missing_subnet_config...
      pass
      # emr-master-no-public-ip.policytest.hcl...
      pass
```

---