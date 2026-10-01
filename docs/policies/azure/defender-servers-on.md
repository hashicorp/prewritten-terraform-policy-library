# Ensure that Defender for Servers Is Set to 'On'

| Provider | Category |
| -------- | -------- |
| Azure    | Security posture management |

## Description

This control checks that the Microsoft Defender for Servers plan is enabled at the Standard tier for virtual machines. It evaluates `azurerm_security_center_subscription_pricing` resources whose `resource_type` is `VirtualMachines`; when that attribute is omitted, the policy treats the resource as the VirtualMachines plan.

The Standard plan provides Defender for Servers protection. A Free tier or missing tier does not satisfy the control.

This rule is covered by the [defender-servers-on](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/azure/security-center/defender-servers-on.policy.hcl) policy.

## Policy Results

```bash
trace:
	# defender-servers-on.policytest.hcl...
	running
	# resource.azurerm_security_center_subscription_pricing.vm_standard...
	running
	# resource.azurerm_security_center_subscription_pricing.vm_standard...
	pass
	# resource.azurerm_security_center_subscription_pricing.vm_free...
	running
	# resource.azurerm_security_center_subscription_pricing.vm_free...
	pass
	# resource.azurerm_security_center_subscription_pricing.vm_default_type_free...
	running
	# resource.azurerm_security_center_subscription_pricing.vm_default_type_free...
	pass
	# resource.azurerm_security_center_subscription_pricing.storage_free...
	running
	# resource.azurerm_security_center_subscription_pricing.storage_free...
	pass
	# resource.azurerm_security_center_subscription_pricing.storage_standard...
	running
	# resource.azurerm_security_center_subscription_pricing.storage_standard...
	pass
	# defender-servers-on.policytest.hcl...
	pass
```

---
