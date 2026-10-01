# Ensure Public Network Access is Disabled for Azure Key Vault

| Provider | Category |
| -------- | -------- |
| Azure    | Network security |

## Description

This control checks whether Azure Key Vault has public network access disabled by setting `public_network_access_enabled` to `false`. Public network access can expose the vault to connections from outside private network boundaries.

The azurerm provider defaults this setting to enabled. The policy therefore treats an omitted or null value as enabled and requires an explicit `false`.

This rule is covered by the [public-network-access-disabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/azure/keyvault/public-network-access-disabled.policy.hcl) policy.

## Policy Results

```bash
trace:
	# public-network-access-disabled.policytest.hcl...
	running
	# resource.azurerm_key_vault.public_access_disabled...
	running
	# resource.azurerm_key_vault.public_access_disabled...
	pass
	# resource.azurerm_key_vault.public_access_enabled...
	running
	# resource.azurerm_key_vault.public_access_enabled...
	pass
	# resource.azurerm_key_vault.public_access_omitted...
	running
	# resource.azurerm_key_vault.public_access_omitted...
	pass
	# resource.azurerm_key_vault.public_access_null...
	running
	# resource.azurerm_key_vault.public_access_null...
	pass
	# public-network-access-disabled.policytest.hcl...
	pass
```

---
