# Ensure that 'Allow Blob Anonymous Access' is Set to 'Disabled'

| Provider | Category |
| -------- | -------- |
| Azure    | Storage security |

## Description

This control checks whether Azure Storage Accounts have anonymous public blob access disabled. When `allow_nested_items_to_be_public` is set to `true`, any blob container within the account can be configured for anonymous access, allowing unauthenticated users to read blob data without any credentials.

Disabling anonymous blob access prevents accidental or intentional exposure of sensitive data stored in blob containers. All access to storage account data should require authentication. Note that `FileStorage` and `BlockBlobStorage` account kinds do not support this attribute and are automatically excluded from enforcement.

This rule is covered by the [blob-anonymous-disabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/azure/storage/blob-anonymous-disabled.policy.hcl) policy.

## Policy Results

```bash
trace:
	# blob-anonymous-disabled.policytest.hcl...
	running
	# resource.azurerm_storage_account.pass_explicitly_disabled...
	running
	# resource.azurerm_storage_account.pass_explicitly_disabled...
	pass
	# resource.azurerm_storage_account.fail_omitted_defaults_to_public...
	running
	# resource.azurerm_storage_account.fail_omitted_defaults_to_public...
	fail
	# resource.azurerm_storage_account.fail_null_defaults_to_public...
	running
	# resource.azurerm_storage_account.fail_null_defaults_to_public...
	fail
	# resource.azurerm_storage_account.pass_file_storage_kind...
	running
	# resource.azurerm_storage_account.pass_file_storage_kind...
	pass
	# resource.azurerm_storage_account.pass_block_blob_storage_kind...
	running
	# resource.azurerm_storage_account.pass_block_blob_storage_kind...
	pass
	# resource.azurerm_storage_account.fail_anonymous_access_enabled...
	running
	# resource.azurerm_storage_account.fail_anonymous_access_enabled...
	fail
	# blob-anonymous-disabled.policytest.hcl...
	pass
```

---
