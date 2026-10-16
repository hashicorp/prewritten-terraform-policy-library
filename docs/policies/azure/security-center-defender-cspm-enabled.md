# Ensure that Microsoft Defender CSPM is Enabled

| Provider | Category |
| -------- | -------- |
| Azure    | Monitoring |

## Description

This control implements CIS Azure Foundations Benchmark v6.0.0 control 8.1.1.1.

This control checks whether Microsoft Defender Cloud Security Posture Management is configured with the `Standard` pricing tier. The tier comparison is case-insensitive. Defender CSPM provides security posture capabilities for identifying risks and improving cloud security.

The policy evaluates `azurerm_security_center_subscription_pricing` resources whose `resource_type` is `CloudPosture` and requires `tier = "Standard"`. Other Defender plans are outside scope.

**Enforcement note:** this resource-level check does not prove that a CloudPosture pricing resource exists when none is present in the Terraform plan. Enabling the Standard tier changes subscription-level settings and may incur charges.

Enforcement defaults to `advisory` and can be configured with the `security-center-defender-cspm-enabled-enforcement-level` input.

This rule is covered by the [security-center-defender-cspm-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/azure/security-center/security-center-defender-cspm-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
	# security-center-defender-cspm-enabled.policytest.hcl...
	running
	# resource.azurerm_security_center_subscription_pricing.pass_cspm_standard...
	running
	# resource.azurerm_security_center_subscription_pricing.pass_cspm_standard...
	pass
	# resource.azurerm_security_center_subscription_pricing.pass_cspm_standard_case_insensitive...
	running
	# resource.azurerm_security_center_subscription_pricing.pass_cspm_standard_case_insensitive...
	pass
	# resource.azurerm_security_center_subscription_pricing.pass_cspm_standard_with_api_posture_extension...
	running
	# resource.azurerm_security_center_subscription_pricing.pass_cspm_standard_with_api_posture_extension...
	pass
	# resource.azurerm_security_center_subscription_pricing.fail_cspm_free...
	running
	# resource.azurerm_security_center_subscription_pricing.fail_cspm_free...
	pass
	# resource.azurerm_security_center_subscription_pricing.fail_cspm_tier_null...
	running
	# resource.azurerm_security_center_subscription_pricing.fail_cspm_tier_null...
	pass
	# resource.azurerm_security_center_subscription_pricing.pass_vm_free...
	running
	# resource.azurerm_security_center_subscription_pricing.pass_vm_free...
	pass
	# resource.azurerm_security_center_subscription_pricing.pass_resource_type_default_free...
	running
	# resource.azurerm_security_center_subscription_pricing.pass_resource_type_default_free...
	pass
	# resource.azurerm_security_center_subscription_pricing.pass_resource_type_null_defaults_free...
	running
	# resource.azurerm_security_center_subscription_pricing.pass_resource_type_null_defaults_free...
	pass
	# resource.azurerm_security_center_subscription_pricing.pass_storage_standard...
	running
	# resource.azurerm_security_center_subscription_pricing.pass_storage_standard...
	pass
	# security-center-defender-cspm-enabled.policytest.hcl...
	pass
```

---
