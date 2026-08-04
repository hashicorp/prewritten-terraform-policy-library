# EFS access points should enforce a root directory

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure access management |

## Description

This control checks if Amazon EFS access points are configured to enforce a root directory. The control fails if the value of Path is set to / (the default root directory of the file system).

When you enforce a root directory, the NFS client using the access point uses the root directory configured on the access point instead of the file system's root directory. Enforcing a root directory for an access point helps restrict data access by ensuring that users of the access point can only reach files of the specified subdirectory.

This rule is covered by the [efs-access-point-enforce-root-directory](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/efs/efs-access-point-enforce-root-directory.policy.hcl) policy.

## Policy Results

```bash
trace:
      # efs-access-point-enforce-root-directory.policytest.hcl... running
      # resource.aws_efs_access_point.pass_with_data_path... running
      # resource.aws_efs_access_point.pass_with_data_path... pass
      # resource.aws_efs_access_point.pass_with_nested_path... running
      # resource.aws_efs_access_point.pass_with_nested_path... pass
      # resource.aws_efs_access_point.pass_with_max_depth_path... running
      # resource.aws_efs_access_point.pass_with_max_depth_path... pass
      # resource.aws_efs_access_point.fail_with_root_slash... running
      # resource.aws_efs_access_point.fail_with_root_slash... pass
      # resource.aws_efs_access_point.fail_without_root_directory... running
      # resource.aws_efs_access_point.fail_without_root_directory... pass
      # resource.aws_efs_access_point.fail_with_empty_path... running
      # resource.aws_efs_access_point.fail_with_empty_path... pass
      # efs-access-point-enforce-root-directory.policytest.hcl... pass
```

---
