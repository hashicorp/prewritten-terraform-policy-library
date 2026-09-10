# Ensure 'Cross Tenant Replication' is Not Enabled

| Provider | Category |
| -------- | -------- |
| Azure    | Storage security |

## Description

This control checks whether Azure Storage Accounts have cross-tenant replication disabled. Cross-tenant replication allows data to be replicated to storage accounts in different Azure Active Directory tenants, which can result in unintended data exfiltration to external organizations.

Disabling cross-tenant replication ensures that object replication policies can only copy data to storage accounts within the same tenant, maintaining data residency and sovereignty requirements. The azurerm provider defaults `cross_tenant_replication_enabled` to `false`, but this must be explicitly verified in policy to prevent accidental enablement.

This rule is covered by the [cross-tenant-replication](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/azure/storage/cross-tenant-replication.policy.hcl) policy.

## Policy Results

```bash
trace:
	# cross-tenant-replication.policytest.hcl...
	running
	# resource.azurerm_storage_account.pass_cross_tenant_replication_disabled...
	running
	# resource.azurerm_storage_account.pass_cross_tenant_replication_disabled...
	pass
	# resource.azurerm_storage_account.pass_cross_tenant_replication_omitted...
	running
	# resource.azurerm_storage_account.pass_cross_tenant_replication_omitted...
	pass
	# resource.azurerm_storage_account.pass_cross_tenant_replication_null...
	running
	# resource.azurerm_storage_account.pass_cross_tenant_replication_null...
	pass
	# resource.azurerm_storage_account.fail_cross_tenant_replication_enabled...
	running
	# resource.azurerm_storage_account.fail_cross_tenant_replication_enabled...
	fail
	# cross-tenant-replication.policytest.hcl...
	pass
```

---
