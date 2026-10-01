# Ensure 'Purge protection' is Set to 'Enabled' for Azure Key Vault

| Provider | Category |
| -------- | -------- |
| Azure    | Data protection |

## Description

This control checks that Azure Key Vault has purge protection enabled by setting `purge_protection_enabled` to `true`. Purge protection prevents a deleted vault or vault object from being permanently purged during its soft-delete retention period.

Without purge protection, a user with sufficient permissions may permanently remove a soft-deleted vault or object before it can be recovered. The policy treats an omitted or null value as disabled.

This rule is covered by the [purge-protection-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/azure/keyvault/purge-protection-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
	# purge-protection-enabled.policytest.hcl...
	running
	# resource.azurerm_key_vault.purge_protection_enabled_passes...
	running
	# resource.azurerm_key_vault.purge_protection_enabled_passes...
	pass
	# resource.azurerm_key_vault.purge_protection_disabled_fails...
	running
	# resource.azurerm_key_vault.purge_protection_disabled_fails...
	pass
	# resource.azurerm_key_vault.purge_protection_absent_fails...
	running
	# resource.azurerm_key_vault.purge_protection_absent_fails...
	pass
	# resource.azurerm_key_vault.purge_protection_null_fails...
	running
	# resource.azurerm_key_vault.purge_protection_null_fails...
	pass
	# purge-protection-enabled.policytest.hcl...
	pass
```

---
