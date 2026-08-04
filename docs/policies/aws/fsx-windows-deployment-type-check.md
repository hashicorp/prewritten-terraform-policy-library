# FSx for Windows File Server file systems should be configured for Multi-AZ deployment

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | High availability |

## Description

This control checks whether an Amazon FSx for Windows File Server file system is configured to use the multiple Availability Zones (Multi-AZ) deployment type. The control fails if the file system isn't configured to use the Multi-AZ deployment type.

Amazon FSx for Windows File Server supports two deployment types for file systems: Single-AZ and Multi-AZ. The deployment types offer different levels of availability and durability. Single-AZ file systems are composed of a single Windows file server instance and a set of storage volumes within a single Availability Zone (AZ). Multi-AZ file systems are composed of a high-availability cluster of Windows file servers spread across two Availability Zones. We recommend using the Multi-AZ deployment type for most production workloads due to the high availability and durability model that it provides.

This rule is covered by the [fsx-windows-deployment-type-check](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/fsx/fsx-windows-deployment-type-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # fsx-windows-deployment-type-check.policytest.hcl... running
      # resource.aws_fsx_windows_file_system.pass_multi_az_1... running
      # resource.aws_fsx_windows_file_system.pass_multi_az_1... pass
      # resource.aws_fsx_windows_file_system.fail_single_az_1... running
      # resource.aws_fsx_windows_file_system.fail_single_az_1... pass
      # resource.aws_fsx_windows_file_system.fail_single_az_2... running
      # resource.aws_fsx_windows_file_system.fail_single_az_2... pass
      # resource.aws_fsx_windows_file_system.fail_missing_deployment_type... running
      # resource.aws_fsx_windows_file_system.fail_missing_deployment_type... pass
      # fsx-windows-deployment-type-check.policytest.hcl... pass
```

---
