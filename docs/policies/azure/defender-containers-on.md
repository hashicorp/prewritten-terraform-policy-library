# Ensure That Microsoft Defender for Containers Is Set to 'On'

| Provider | Category |
| -------- | -------- |
| Azure    | Security posture management |

## Description

This control checks that the Microsoft Defender for Containers plan is enabled at the Standard tier and includes all four required monitoring extensions: `ContainerRegistriesVulnerabilityAssessments`, `AgentlessDiscoveryForKubernetes`, `AgentlessVmScanning`, and `ContainerSensor`.

Enabling the plan without its required extensions leaves gaps in container, registry, Kubernetes, and virtual machine monitoring. The policy evaluates `azurerm_security_center_subscription_pricing` resources with `resource_type = "Containers"`.

The CIS 8.1.4.1 audit requires each of these four extensions to have `isEnabled = True`. In the AzureRM provider, an extension is enabled only when it is declared with an `extension` block, and any extension without a block is disabled. To pass this policy, declare a separate `extension` block for each of the four extensions, for example:

```hcl
resource "azurerm_security_center_subscription_pricing" "containers" {
  tier          = "Standard"
  resource_type = "Containers"

  extension {
    name = "ContainerRegistriesVulnerabilityAssessments"
  }
  extension {
    name = "AgentlessDiscoveryForKubernetes"
  }
  extension {
    name = "AgentlessVmScanning"
  }
  extension {
    name = "ContainerSensor"
  }
}
```

This rule is covered by the [defender-containers-on](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/azure/security-center/defender-containers-on.policy.hcl) policy.

## Policy Results

```bash
trace:
	# defender-containers-on.policytest.hcl...
	running
	# resource.azurerm_security_center_subscription_pricing.containers_standard_all_extensions...
	running
	# resource.azurerm_security_center_subscription_pricing.containers_standard_all_extensions...
	pass
	# resource.azurerm_security_center_subscription_pricing.containers_free...
	running
	# resource.azurerm_security_center_subscription_pricing.containers_free...
	pass
	# resource.azurerm_security_center_subscription_pricing.containers_tier_absent...
	running
	# resource.azurerm_security_center_subscription_pricing.containers_tier_absent...
	pass
	# resource.azurerm_security_center_subscription_pricing.containers_tier_empty...
	running
	# resource.azurerm_security_center_subscription_pricing.containers_tier_empty...
	pass
	# resource.azurerm_security_center_subscription_pricing.containers_standard_no_extensions...
	running
	# resource.azurerm_security_center_subscription_pricing.containers_standard_no_extensions...
	pass
	# resource.azurerm_security_center_subscription_pricing.containers_standard_partial_extensions...
	running
	# resource.azurerm_security_center_subscription_pricing.containers_standard_partial_extensions...
	pass
	# resource.azurerm_security_center_subscription_pricing.vms_free...
	running
	# resource.azurerm_security_center_subscription_pricing.vms_free...
	pass
	# resource.azurerm_security_center_subscription_pricing.storage_standard...
	running
	# resource.azurerm_security_center_subscription_pricing.storage_standard...
	pass
	# resource.azurerm_security_center_subscription_pricing.type_absent_free...
	running
	# resource.azurerm_security_center_subscription_pricing.type_absent_free...
	pass
	# defender-containers-on.policytest.hcl...
	pass
```

---
