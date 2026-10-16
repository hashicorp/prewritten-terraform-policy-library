# Ensure that Microsoft Defender for Resource Manager is Enabled

| Provider | Category |
| -------- | -------- |
| Azure    | Monitoring |

## Description

This control implements CIS Azure Foundations Benchmark v6.0.0 control 8.1.9.1.

This control checks whether Microsoft Defender for Resource Manager uses the `Standard` pricing tier. This Defender plan helps detect suspicious resource-management operations affecting an Azure subscription.

The policy evaluates `azurerm_security_center_subscription_pricing` resources with `resource_type = "Arm"` and requires `tier = "Standard"`. Resource type and tier comparisons are case-insensitive. Other Defender plans are outside scope.

**Enforcement note:** this resource-level check does not require an Arm pricing resource to be present in a plan that declares none. Enabling the Standard tier changes subscription-level settings and may incur charges.

Enforcement defaults to `advisory` and can be configured with the `security-center-defender-resource-manager-enabled-enforcement-level` input.

This rule is covered by the [security-center-defender-resource-manager-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/azure/security-center/security-center-defender-resource-manager-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
	# security-center-defender-resource-manager-enabled.policytest.hcl...
	running
	# resource.azurerm_security_center_subscription_pricing.pass_arm_standard...
	running
	# resource.azurerm_security_center_subscription_pricing.pass_arm_standard...
	pass
	# resource.azurerm_security_center_subscription_pricing.pass_arm_lowercase_standard...
	running
	# resource.azurerm_security_center_subscription_pricing.pass_arm_lowercase_standard...
	pass
	# resource.azurerm_security_center_subscription_pricing.fail_arm_free...
	running
	# resource.azurerm_security_center_subscription_pricing.fail_arm_free...
	pass
	# resource.azurerm_security_center_subscription_pricing.fail_arm_null_tier...
	running
	# resource.azurerm_security_center_subscription_pricing.fail_arm_null_tier...
	pass
	# resource.azurerm_security_center_subscription_pricing.pass_other_type_free...
	running
	# resource.azurerm_security_center_subscription_pricing.pass_other_type_free...
	pass
	# resource.azurerm_security_center_subscription_pricing.pass_resource_type_default_free...
	running
	# resource.azurerm_security_center_subscription_pricing.pass_resource_type_default_free...
	pass
	# resource.azurerm_security_center_subscription_pricing.pass_resource_type_null_defaults_free...
	running
	# resource.azurerm_security_center_subscription_pricing.pass_resource_type_null_defaults_free...
	pass
	# resource.azurerm_security_center_subscription_pricing.pass_arm_standard_with_null_subplan...
	running
	# resource.azurerm_security_center_subscription_pricing.pass_arm_standard_with_null_subplan...
	pass
	# security-center-defender-resource-manager-enabled.policytest.hcl...
	pass
```

---
