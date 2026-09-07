# Ensure 'Allow storage account key access' for Azure Storage Accounts is 'Disabled'

| Provider | Category |
| -------- | -------- |
| Azure    | Identity and access management |

## Description

This control checks whether Azure Storage Accounts have Shared Key authorization disabled by explicitly setting `shared_access_key_enabled` to `false`. When enabled, Shared Key authorization allows anyone with the account key to access all data in the storage account with full permissions, bypassing Azure RBAC and Entra ID access controls.

Disabling Shared Key authorization forces all requests — including shared access signatures — to be authorized using Azure Active Directory, providing stronger identity-based access control. The azurerm provider defaults `shared_access_key_enabled` to `true`, so it must be explicitly set to `false` to satisfy this control.

This rule is covered by the [disable-shared-key](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/azure/storage/disable-shared-key.policy.hcl) policy.

## Policy Results

```bash
trace:
	# disable-shared-key.policytest.hcl...
	running
	# resource.azurerm_storage_account.pass_shared_key_disabled...
	running
	# resource.azurerm_storage_account.pass_shared_key_disabled...
	pass
	# resource.azurerm_storage_account.fail_shared_key_enabled...
	running
	# resource.azurerm_storage_account.fail_shared_key_enabled...
	fail
	# resource.azurerm_storage_account.fail_shared_key_omitted...
	running
	# resource.azurerm_storage_account.fail_shared_key_omitted...
	fail
	# resource.azurerm_storage_account.fail_shared_key_null...
	running
	# resource.azurerm_storage_account.fail_shared_key_null...
	fail
	# disable-shared-key.policytest.hcl...
	pass
```

---
