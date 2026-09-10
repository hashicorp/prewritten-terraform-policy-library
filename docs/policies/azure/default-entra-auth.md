# Ensure that 'Default to Microsoft Entra authorization in the Azure portal' is Set to 'Enabled'

| Provider | Category |
| -------- | -------- |
| Azure    | Identity and access management |

## Description

This control checks whether Azure Storage Accounts have the default authorization method in the Azure portal set to Microsoft Entra ID (formerly Azure Active Directory). When `default_to_oauth_authentication` is `true`, the Azure portal uses Entra ID credentials by default instead of storage account keys when users access blob and queue data.

Using Entra ID as the default authorization method encourages the use of identity-based access over shared key authorization, reducing the risk of credential exposure. Storage account keys provide unrestricted access to all data in the account and should not be the default portal access method.

This rule is covered by the [default-entra-auth](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/azure/storage/default-entra-auth.policy.hcl) policy.

## Policy Results

```bash
trace:
	# default-entra-auth.policytest.hcl...
	running
	# resource.azurerm_storage_account.entra_authorization_enabled...
	running
	# resource.azurerm_storage_account.entra_authorization_enabled...
	pass
	# resource.azurerm_storage_account.entra_authorization_disabled...
	running
	# resource.azurerm_storage_account.entra_authorization_disabled...
	fail
	# resource.azurerm_storage_account.entra_authorization_omitted...
	running
	# resource.azurerm_storage_account.entra_authorization_omitted...
	fail
	# resource.azurerm_storage_account.entra_authorization_null...
	running
	# resource.azurerm_storage_account.entra_authorization_null...
	fail
	# default-entra-auth.policytest.hcl...
	pass
```

---
