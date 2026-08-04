# WorkSpaces root volumes should be encrypted at rest

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks whether a root volume in an Amazon WorkSpaces WorkSpace is encrypted at rest. The control fails if the WorkSpace root volume isn't encrypted at rest.

Data at rest refers to data that's stored in persistent, non-volatile storage for any duration. Encrypting data at rest helps you protect its confidentiality, which reduces the risk that an unauthorized user can access it.

This rule is covered by the [workspaces-root-volume-encryption-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/workspaces/workspaces-root-volume-encryption-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # workspaces-root-volume-encryption-enabled.policytest.hcl... running
      # resource.aws_workspaces_workspace.pass_root_volume_encrypted... running
      # resource.aws_workspaces_workspace.pass_root_volume_encrypted... pass
      # resource.aws_workspaces_workspace.fail_root_volume_not_encrypted... running
      # resource.aws_workspaces_workspace.fail_root_volume_not_encrypted... pass
      # resource.aws_workspaces_workspace.fail_root_volume_missing_encryption... running
      # resource.aws_workspaces_workspace.fail_root_volume_missing_encryption... pass
      # workspaces-root-volume-encryption-enabled.policytest.hcl... pass
```

---
