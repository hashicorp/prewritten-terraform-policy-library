# Ensure the 'Minimum TLS version' for Storage Accounts is Set to 'Version 1.2'

| Provider | Category |
| -------- | -------- |
| Azure    | Encryption of data-in-transit |

## Description

This control checks whether Azure Storage Accounts enforce a minimum TLS version of 1.2. Older TLS versions (1.0 and 1.1) contain known vulnerabilities and are considered cryptographically weak. All client connections must use TLS 1.2 or higher to ensure data in transit is protected with current encryption standards.

The azurerm provider defaults `min_tls_version` to `TLS1_2` for new storage accounts, so omitting the attribute is compliant. Only explicit values of `TLS1_0` or `TLS1_1` violate this control.

This rule is covered by the [storage-tls12](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/azure/storage/storage-tls12.policy.hcl) policy.

## Policy Results

```bash
trace:
	# storage-tls12.policytest.hcl...
	running
	# resource.azurerm_storage_account.pass_tls_1_2...
	running
	# resource.azurerm_storage_account.pass_tls_1_2...
	pass
	# resource.azurerm_storage_account.fail_tls_1_0...
	running
	# resource.azurerm_storage_account.fail_tls_1_0...
	fail
	# resource.azurerm_storage_account.pass_missing_min_tls_version...
	running
	# resource.azurerm_storage_account.pass_missing_min_tls_version...
	pass
	# resource.azurerm_storage_account.fail_empty_min_tls_version...
	running
	# resource.azurerm_storage_account.fail_empty_min_tls_version...
	fail
	# resource.azurerm_storage_account.pass_null_min_tls_version...
	running
	# resource.azurerm_storage_account.pass_null_min_tls_version...
	pass
	# storage-tls12.policytest.hcl...
	pass
```

---
