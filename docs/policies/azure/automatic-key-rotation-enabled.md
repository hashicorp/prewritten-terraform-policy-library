# Ensure Automatic Key Rotation is Enabled within Azure Key Vault

| Provider | Category |
| -------- | -------- |
| Azure    | Data protection |

## Description

This control checks whether Azure Key Vault keys define an automatic `rotation_policy`. The policy must contain an `automatic` block with a non-empty `time_after_creation` or `time_before_expiry` trigger so that key rotation is scheduled.

Without automatic rotation, long-lived keys can remain in use indefinitely, increasing the impact of a compromised key. A rotation policy with no schedule trigger does not meet this requirement.

This rule is covered by the [automatic-key-rotation-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/azure/keyvault/automatic-key-rotation-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
	# automatic-key-rotation-enabled.policytest.hcl...
	running
	# resource.azurerm_key_vault_key.pass_time_after_creation...
	running
	# resource.azurerm_key_vault_key.pass_time_after_creation...
	pass
	# resource.azurerm_key_vault_key.pass_time_before_expiry...
	running
	# resource.azurerm_key_vault_key.pass_time_before_expiry...
	pass
	# resource.azurerm_key_vault_key.fail_no_rotation_policy...
	running
	# resource.azurerm_key_vault_key.fail_no_rotation_policy...
	pass
	# resource.azurerm_key_vault_key.fail_no_automatic...
	running
	# resource.azurerm_key_vault_key.fail_no_automatic...
	pass
	# resource.azurerm_key_vault_key.fail_automatic_no_trigger...
	running
	# resource.azurerm_key_vault_key.fail_automatic_no_trigger...
	pass
	# resource.azurerm_key_vault_key.fail_automatic_empty_list...
	running
	# resource.azurerm_key_vault_key.fail_automatic_empty_list...
	pass
	# automatic-key-rotation-enabled.policytest.hcl...
	pass
```

---
