# FSx for OpenZFS file systems should be configured for Multi-AZ deployment

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | High availability |

## Description

This control checks whether an Amazon FSx for OpenZFS file system is configured to use the multiple Availability Zones (Multi-AZ) deployment type. The control fails if the file system isn't configured to use the Multi-AZ deployment type.

Amazon FSx for OpenZFS supports several deployment types for file systems: Multi-AZ (HA), Single-AZ (HA), and Single-AZ (non-HA). The deployment types offer different levels of availability and durability. Multi-AZ (HA) file systems are composed of a high-availability (HA) pair of file servers that are spread across two Availability Zones (AZs). We recommend using the Multi-AZ (HA) deployment type for most production workloads due to the high availability and durability model that it provides.

This rule is covered by the [fsx-openzfs-deployment-type-check](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/fsx/fsx-openzfs-deployment-type-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # fsx-openzfs-deployment-type-check.policytest.hcl... running
      # resource.aws_fsx_openzfs_file_system.pass_multi_az_1... running
      # resource.aws_fsx_openzfs_file_system.pass_multi_az_1... pass
      # resource.aws_fsx_openzfs_file_system.fail_single_az_1... running
      # resource.aws_fsx_openzfs_file_system.fail_single_az_1... pass
      # resource.aws_fsx_openzfs_file_system.fail_single_az_2... running
      # resource.aws_fsx_openzfs_file_system.fail_single_az_2... pass
      # fsx-openzfs-deployment-type-check.policytest.hcl... pass
```

---
