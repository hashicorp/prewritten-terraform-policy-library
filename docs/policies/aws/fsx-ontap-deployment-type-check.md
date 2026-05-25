# FSx for NetApp ONTAP file systems should be configured for Multi-AZ deployment

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | High availability |

## Description

This control checks whether an Amazon FSx for NetApp ONTAP file system is configured to use a multiple Availability Zones (Multi-AZ) deployment type. The control fails if the file system isn't configured to use a Multi-AZ deployment type. You can optionally specify a list of deployment types to include in the evaluation.

Amazon FSx for NetApp ONTAP supports several deployment types for file systems: Single-AZ 1, Single-AZ 2, Multi-AZ 1, and Multi-AZ 2. The deployment types offer different levels of availability and durability. We recommend using a Multi-AZ deployment type for most production workloads due to the high availability and durability model that Multi-AZ deployment types provide. Multi-AZ file systems support all the availability and durability features of Single-AZ file systems. In addition, they're designed to provide continuous availability to data even when an Availability Zone (AZ) is unavailable.

This rule is covered by the [fsx-ontap-deployment-type-check](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/fsx/fsx-ontap-deployment-type-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # fsx-ontap-deployment-type-check.policytest.hcl... running
      # resource.aws_fsx_ontap_file_system.pass_multi_az_1... running
      # resource.aws_fsx_ontap_file_system.pass_multi_az_1... pass
      # resource.aws_fsx_ontap_file_system.pass_multi_az_2... running
      # resource.aws_fsx_ontap_file_system.pass_multi_az_2... pass
      # resource.aws_fsx_ontap_file_system.fail_single_az... running
      # resource.aws_fsx_ontap_file_system.fail_single_az... pass
      # fsx-ontap-deployment-type-check.policytest.hcl... pass
```

---
