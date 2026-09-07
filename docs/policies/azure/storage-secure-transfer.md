# Ensure Storage Secure Transfer Is Enabled

| Provider | Category |
| -------- | -------- |
| Azure    | Encryption of data-in-transit |

## Description

This control checks whether Azure Storage Accounts require secure transfer by having `https_traffic_only_enabled` set to `true`. When secure transfer is enabled, the storage account rejects all HTTP requests, ensuring that all data in transit is encrypted using HTTPS/TLS.

Without secure transfer enforcement, clients can communicate with the storage account over unencrypted HTTP, exposing data to interception. The azurerm provider defaults `https_traffic_only_enabled` to `true`, so omitting the attribute is compliant — only an explicit `false` value violates this control.

This rule is covered by the [storage-secure-transfer](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/azure/storage/storage-secure-transfer.policy.hcl) policy.

## Policy Results

```bash
trace:
	# storage-secure-transfer.policytest.hcl...
	running
	# resource.azurerm_storage_account.secure_transfer_enabled...
	running
	# resource.azurerm_storage_account.secure_transfer_enabled...
	pass
	# resource.azurerm_storage_account.secure_transfer_omitted...
	running
	# resource.azurerm_storage_account.secure_transfer_omitted...
	pass
	# resource.azurerm_storage_account.secure_transfer_null...
	running
	# resource.azurerm_storage_account.secure_transfer_null...
	pass
	# resource.azurerm_storage_account.secure_transfer_disabled...
	running
	# resource.azurerm_storage_account.secure_transfer_disabled...
	fail
	# storage-secure-transfer.policytest.hcl...
	pass
```

---
