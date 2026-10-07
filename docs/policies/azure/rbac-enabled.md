# Ensure Azure Key Vault Uses the Azure RBAC Permission Model

| Provider | Category |
| -------- | -------- |
| Azure    | Identity and access management |

## Description

This control checks that Azure Key Vault uses Azure role-based access control for data-plane authorization. The policy requires AzureRM provider version 5.7.0 or later and checks that `rbac_authorization_enabled` is set to `true`.

Using Azure RBAC centralizes access management with Azure role assignments and avoids managing a separate Key Vault access-policy model. An omitted, null, or false value does not satisfy the requirement.

This rule is covered by the [rbac-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/azure/keyvault/rbac-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
	# rbac-enabled.policytest.hcl...
	running
	# resource.azurerm_key_vault.rbac_enabled...
	running
	pass
	# resource.azurerm_key_vault.rbac_disabled...
	running
	# resource.azurerm_key_vault.rbac_disabled...
	pass
	# resource.azurerm_key_vault.rbac_absent...
	running
	# resource.azurerm_key_vault.rbac_absent...
	pass
	# resource.azurerm_key_vault.rbac_null...
	running
	# resource.azurerm_key_vault.rbac_null...
	pass
	# rbac-enabled.policytest.hcl...
	pass
```

---
