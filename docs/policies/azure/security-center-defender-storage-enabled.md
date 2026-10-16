# Ensure that Microsoft Defender for Storage is Enabled

| Provider | Category |
| -------- | -------- |
| Azure    | Monitoring |

## Description

This control implements CIS Azure Foundations Benchmark v6.0.0 control 8.1.5.1.

This control checks whether Microsoft Defender for Storage uses the `Standard` pricing tier. Defender for Storage helps detect threats and suspicious activity affecting Azure storage services.

The policy evaluates `azurerm_security_center_subscription_pricing` resources with `resource_type = "StorageAccounts"` and requires `tier = "Standard"`. Resource type and tier comparisons are case-insensitive. Other pricing resources are outside scope.

**Enforcement note:** this control checks the pricing tier, not a particular subplan or extension. It does not enforce the existence of a pricing resource when the plan contains none. Enabling Defender can incur subscription-level charges.

Enforcement defaults to `advisory` and can be configured with the `security-center-defender-storage-enabled-enforcement-level` input.

This rule is covered by the [security-center-defender-storage-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/azure/security-center/security-center-defender-storage-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
	# security-center-defender-storage-enabled.policytest.hcl...
	running
	# resource.azurerm_security_center_subscription_pricing.pass_storage_standard...
	running
	# resource.azurerm_security_center_subscription_pricing.pass_storage_standard...
	pass
	# resource.azurerm_security_center_subscription_pricing.pass_storage_standard_with_subplan...
	running
	# resource.azurerm_security_center_subscription_pricing.pass_storage_standard_with_subplan...
	pass
	# resource.azurerm_security_center_subscription_pricing.pass_storage_lowercase_standard...
	running
	# resource.azurerm_security_center_subscription_pricing.pass_storage_lowercase_standard...
	pass
	# resource.azurerm_security_center_subscription_pricing.fail_storage_free...
	running
	# resource.azurerm_security_center_subscription_pricing.fail_storage_free...
	pass
	# resource.azurerm_security_center_subscription_pricing.fail_storage_free_with_subplan...
	running
	# resource.azurerm_security_center_subscription_pricing.fail_storage_free_with_subplan...
	pass
	# resource.azurerm_security_center_subscription_pricing.fail_storage_null_tier...
	running
	# resource.azurerm_security_center_subscription_pricing.fail_storage_null_tier...
	pass
	# resource.azurerm_security_center_subscription_pricing.pass_other_plan_free...
	running
	# resource.azurerm_security_center_subscription_pricing.pass_other_plan_free...
	pass
	# resource.azurerm_security_center_subscription_pricing.pass_resource_type_default_free...
	running
	# resource.azurerm_security_center_subscription_pricing.pass_resource_type_default_free...
	pass
	# resource.azurerm_security_center_subscription_pricing.pass_resource_type_null_defaults_free...
	running
	# resource.azurerm_security_center_subscription_pricing.pass_resource_type_null_defaults_free...
	pass
	# security-center-defender-storage-enabled.policytest.hcl...
	pass
```

---
