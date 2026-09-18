# Ensure "Block Project-Wide SSH Keys" Is Enabled for VM Instances

| Provider | Category |
| -------- | -------- |
| Google Cloud Platform | Compute security |

## Description

This control checks whether a `google_compute_instance` sets the `block-project-ssh-keys` metadata key to a truthy value, blocking the instance from accepting project-wide SSH keys. GCP treats this metadata value as case-insensitive and accepts several truthy aliases (`true`, `TRUE`, `Y`, `Yes`, `1`); any of these are treated as compliant.

Project-wide SSH keys are shared across every instance in a project. If an instance accepts them, anyone with a project-wide key configured (which may include former employees, other teams, or overly broad automation) can SSH into that instance, even if it was intended to only accept instance-specific keys. Enabling `block-project-ssh-keys` forces the instance to only trust keys explicitly added to its own instance-level metadata, reducing the number of principals with SSH access to any given VM.

This rule is covered by the [4-3-block-ssh-keys](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/gcp/compute/4-3-block-ssh-keys.policy.hcl) policy.

## Policy Results

```bash
trace:
   # 4-3-block-ssh-keys.policytest.hcl... 
   running
   # resource.google_compute_instance.pass_block_project_ssh_keys_true... 
   running
   # resource.google_compute_instance.pass_block_project_ssh_keys_true... 
   pass
   # resource.google_compute_instance.fail_metadata_omitted... 
   running
   # resource.google_compute_instance.fail_metadata_omitted... 
   pass
   # resource.google_compute_instance.fail_metadata_empty... 
   running
   # resource.google_compute_instance.fail_metadata_empty... 
   pass
   # resource.google_compute_instance.fail_metadata_null... 
   running
   # resource.google_compute_instance.fail_metadata_null... 
   pass
   # resource.google_compute_instance.pass_block_project_ssh_keys_lowercase... 
   running
   # resource.google_compute_instance.pass_block_project_ssh_keys_lowercase... 
   pass
   # resource.google_compute_instance.fail_block_project_ssh_keys_invalid_value... 
   running
   # resource.google_compute_instance.fail_block_project_ssh_keys_invalid_value... 
   pass
   # 4-3-block-ssh-keys.policytest.hcl... 
   pass
```

---
