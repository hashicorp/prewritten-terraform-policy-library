# EFS access points should enforce a user identity

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure access management |

## Description

This control checks whether Amazon EFS access points are configured to enforce a user identity. This control fails if a POSIX user identity is not defined while creating the EFS access point.

Amazon EFS access points are application-specific entry points into an EFS file system that make it easier to manage application access to shared datasets. Access points can enforce a user identity, including the user's POSIX groups, for all file system requests that are made through the access point. Access points can also enforce a different root directory for the file system so that clients can only access data in the specified directory or its subdirectories.

This rule is covered by the [efs-access-point-enforce-user-identity](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/efs/efs-access-point-enforce-user-identity.policy.hcl) policy.

## Policy Results

```bash
trace:
      # efs-access-point-enforce-user-identity.policytest.hcl...
      running
      # resource.aws_efs_access_point.pass_complete_posix_user...
      running
      # resource.aws_efs_access_point.pass_complete_posix_user...
      pass
      # resource.aws_efs_access_point.pass_with_secondary_gids...
      running
      # resource.aws_efs_access_point.pass_with_secondary_gids...
      pass
      # resource.aws_efs_access_point.fail_missing_posix_user...
      running
      # resource.aws_efs_access_point.fail_missing_posix_user...
      pass
      # resource.aws_efs_access_point.fail_missing_uid...
      running
      # resource.aws_efs_access_point.fail_missing_uid...
      pass
      # resource.aws_efs_access_point.fail_missing_gid...
      running
      # resource.aws_efs_access_point.fail_missing_gid...
      pass
      # resource.aws_efs_access_point.fail_empty_posix_user...
      running
      # resource.aws_efs_access_point.fail_empty_posix_user...
      pass
      # efs-access-point-enforce-user-identity.policytest.hcl...
      pass
```

---
