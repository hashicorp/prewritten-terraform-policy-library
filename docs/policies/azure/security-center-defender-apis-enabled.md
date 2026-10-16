# Ensure Microsoft Defender for APIs is Set to 'On'

| Provider | Category |
| -------- | -------- |
| Azure    | Security posture management |

## Description

This control checks that Microsoft Defender for APIs is enabled at the Standard tier. It evaluates `azurerm_security_center_subscription_pricing` resources with `resource_type = "Api"`.

Defender for APIs provides visibility into API security posture and detects threats against APIs. A Free tier, omitted tier, or other tier does not meet the control. Azure also requires a `subplan` (`P1` to `P5`) when enabling this plan; the policy checks only the tier.

This rule is covered by the [security-center-defender-apis-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/azure/security-center/security-center-defender-apis-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
	# security-center-defender-apis-enabled.policytest.hcl...
	running
	# resource.azurerm_security_center_subscription_pricing.api_standard_pass...
	running
	# resource.azurerm_security_center_subscription_pricing.api_standard_pass...
	pass
	# resource.azurerm_security_center_subscription_pricing.api_free_fail...
	running
	# resource.azurerm_security_center_subscription_pricing.api_free_fail...
	pass
	# resource.azurerm_security_center_subscription_pricing.api_tier_absent_fail...
	running
	# resource.azurerm_security_center_subscription_pricing.api_tier_absent_fail...
	pass
	# resource.azurerm_security_center_subscription_pricing.api_tier_null_fail...
	running
	# resource.azurerm_security_center_subscription_pricing.api_tier_null_fail...
	pass
	# resource.azurerm_security_center_subscription_pricing.non_api_free_pass...
	running
	# resource.azurerm_security_center_subscription_pricing.non_api_free_pass...
	pass
	# resource.azurerm_security_center_subscription_pricing.non_api_standard_pass...
	running
	# resource.azurerm_security_center_subscription_pricing.non_api_standard_pass...
	pass
	# security-center-defender-apis-enabled.policytest.hcl...
	pass
```

---
