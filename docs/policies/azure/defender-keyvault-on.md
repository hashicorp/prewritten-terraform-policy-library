# Ensure That Microsoft Defender for Key Vault Is Set to 'On'

| Provider | Category |
| -------- | -------- |
| Azure    | Security posture management |

## Description

This control checks that Microsoft Defender for Key Vault is enabled at the Standard tier. It evaluates `azurerm_security_center_subscription_pricing` resources with `resource_type = "KeyVaults"`.

The Standard plan provides Defender protections for Azure Key Vault. A Free tier, omitted tier, or other tier does not meet the control.

This rule is covered by the [defender-keyvault-on](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/azure/security-center/defender-keyvault-on.policy.hcl) policy.

## Policy Results

```bash
trace:
	# defender-keyvault-on.policytest.hcl...
	running
	# resource.azurerm_security_center_subscription_pricing.keyvaults_standard...
	running
	# resource.azurerm_security_center_subscription_pricing.keyvaults_standard...
	pass
	# resource.azurerm_security_center_subscription_pricing.keyvaults_free...
	running
	# resource.azurerm_security_center_subscription_pricing.keyvaults_free...
	pass
	# resource.azurerm_security_center_subscription_pricing.keyvaults_tier_absent...
	running
	# resource.azurerm_security_center_subscription_pricing.keyvaults_tier_absent...
	pass
	# resource.azurerm_security_center_subscription_pricing.vm_free_out_of_scope...
	running
	# resource.azurerm_security_center_subscription_pricing.vm_free_out_of_scope...
	pass
	# resource.azurerm_security_center_subscription_pricing.vm_standard_out_of_scope...
	running
	# resource.azurerm_security_center_subscription_pricing.vm_standard_out_of_scope...
	pass
	# defender-keyvault-on.policytest.hcl...
	pass
```

---
