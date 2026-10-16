# Ensure that Storage Accounts Use Geo-Redundant Replication

| Provider | Category |
| -------- | -------- |
| Azure    | Data protection |

## Description

This policy is related to CIS Azure Foundations Benchmark v6.0.0 control 9.3.11. CIS scopes the control to critical storage accounts, but this policy has no criticality or tag selector and therefore evaluates every declared `azurerm_storage_account`.

This control checks whether Azure storage accounts configure geo-redundant replication. Replication to a secondary region helps protect data availability during a regional outage.

Set `account_replication_type` to `GRS`, `RAGRS`, `GZRS`, or `RAGZRS`. Local and zone-only replication types do not meet this requirement.

**Enforcement note:** this policy does not exempt account kinds with restricted replication options. A passing configuration check does not prove current replication health or that a disaster-recovery procedure has been tested.

Enforcement defaults to `advisory` and can be configured with the `storage-geo-redundant-replication-enabled-enforcement-level` input.

This rule is covered by the [storage-geo-redundant-replication-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/azure/storage/storage-geo-redundant-replication-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
	# storage-geo-redundant-replication-enabled.policytest.hcl...
	running
	# resource.azurerm_storage_account.pass_grs...
	running
	# resource.azurerm_storage_account.pass_grs...
	pass
	# resource.azurerm_storage_account.pass_ragrs...
	running
	# resource.azurerm_storage_account.pass_ragrs...
	pass
	# resource.azurerm_storage_account.pass_gzrs...
	running
	# resource.azurerm_storage_account.pass_gzrs...
	pass
	# resource.azurerm_storage_account.pass_ragzrs...
	running
	# resource.azurerm_storage_account.pass_ragzrs...
	pass
	# resource.azurerm_storage_account.fail_lrs...
	running
	# resource.azurerm_storage_account.fail_lrs...
	pass
	# resource.azurerm_storage_account.fail_zrs...
	running
	# resource.azurerm_storage_account.fail_zrs...
	pass
	# resource.azurerm_storage_account.fail_premium_lrs...
	running
	# resource.azurerm_storage_account.fail_premium_lrs...
	pass
	# storage-geo-redundant-replication-enabled.policytest.hcl...
	pass
```

---
