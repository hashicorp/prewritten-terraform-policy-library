# Ensure 'No Public IP' is Set to 'Enabled'

| Provider | Category |
| -------- | -------- |
| Azure    | Network security |

## Description

This control checks that Secure Cluster Connectivity (No Public IP) is enabled on every Azure Databricks workspace. It evaluates `azurerm_databricks_workspace` resources and fails when `custom_parameters.no_public_ip` is set to `false`.

With No Public IP enabled, cluster nodes have no public IP addresses and no open inbound ports. If `no_public_ip` is omitted, the policy treats it as enabled because the AzureRM provider defaults it to `true`.

This rule is covered by the [databricks-no-public-ip-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/azure/databricks/databricks-no-public-ip-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
	# databricks-no-public-ip-enabled.policytest.hcl...
	running
	# resource.azurerm_databricks_workspace.no_public_ip_enabled...
	running
	# resource.azurerm_databricks_workspace.no_public_ip_enabled...
	pass
	# resource.azurerm_databricks_workspace.no_public_ip_disabled...
	running
	# resource.azurerm_databricks_workspace.no_public_ip_disabled...
	pass
	# resource.azurerm_databricks_workspace.no_public_ip_omitted_in_block...
	running
	# resource.azurerm_databricks_workspace.no_public_ip_omitted_in_block...
	pass
	# resource.azurerm_databricks_workspace.custom_parameters_absent...
	running
	# resource.azurerm_databricks_workspace.custom_parameters_absent...
	pass
	# resource.azurerm_databricks_workspace.no_public_ip_null...
	running
	# resource.azurerm_databricks_workspace.no_public_ip_null...
	pass
	# databricks-no-public-ip-enabled.policytest.hcl...
	pass
```

---
