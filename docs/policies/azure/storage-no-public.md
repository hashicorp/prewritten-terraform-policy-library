# Ensure that 'Public Network Access' is 'Disabled' for Storage Accounts

| Provider | Category |
| -------- | -------- |
| Azure    | Network security |

## Description

This control checks whether Azure Storage Accounts have public network access disabled by setting `public_network_access_enabled` to `false`. Allowing public network access to a storage account exposes it to the internet, increasing the risk of unauthorized access, data exfiltration, and denial-of-service attacks.

Disabling public network access restricts connectivity to the storage account to private endpoints and trusted Azure services only. The azurerm provider defaults `public_network_access_enabled` to `true`, meaning all new storage accounts are publicly accessible unless this is explicitly disabled.

This rule is covered by the [storage-no-public](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/azure/storage/storage-no-public.policy.hcl) policy.

## Policy Results

```bash
trace:
	# storage-no-public.policytest.hcl...
	running
	# resource.azurerm_storage_account.pass_public_network_access_disabled...
	running
	# resource.azurerm_storage_account.pass_public_network_access_disabled...
	pass
	# resource.azurerm_storage_account.fail_public_network_access_enabled...
	running
	# resource.azurerm_storage_account.fail_public_network_access_enabled...
	fail
	# resource.azurerm_storage_account.fail_public_network_access_omitted...
	running
	# resource.azurerm_storage_account.fail_public_network_access_omitted...
	fail
	# resource.azurerm_storage_account.fail_public_network_access_null...
	running
	# resource.azurerm_storage_account.fail_public_network_access_null...
	fail
	# storage-no-public.policytest.hcl...
	pass
```

---
