# WorkSpaces user volumes should be encrypted at rest

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks whether a user volume in an Amazon WorkSpaces WorkSpace is encrypted at rest. The control fails if the WorkSpace user volume isn't encrypted at rest.

Data at rest refers to data that's stored in persistent, non-volatile storage for any duration. Encrypting data at rest helps you protect its confidentiality, which reduces the risk that an unauthorized user can access it.

This rule is covered by the [workspaces-user-volume-encryption-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/workspaces/workspaces-user-volume-encryption-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # workspaces-user-volume-encryption-enabled.policytest.hcl... running
      # resource.aws_workspaces_workspace.pass_user_volume_encrypted... running
      # resource.aws_workspaces_workspace.pass_user_volume_encrypted... pass
      # resource.aws_workspaces_workspace.fail_user_volume_not_encrypted... running
      # resource.aws_workspaces_workspace.fail_user_volume_not_encrypted... pass
      # resource.aws_workspaces_workspace.fail_user_volume_missing_encryption... running
      # resource.aws_workspaces_workspace.fail_user_volume_missing_encryption... pass
      # workspaces-user-volume-encryption-enabled.policytest.hcl... pass
```

---
