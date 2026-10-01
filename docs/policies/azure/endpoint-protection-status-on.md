# Ensure that 'Endpoint protection' Component Status Is Set to 'On'

| Provider | Category |
| -------- | -------- |
| Azure    | Security posture management |

## Description

This control checks that the endpoint protection setting is enabled in Microsoft Defender for Cloud. The policy applies to `azurerm_security_center_setting` resources with `setting_name` set to `WDATP` or `WDATP_UNIFIED_SOLUTION` and requires `enabled = true`.

Other Defender for Cloud setting names are outside the policy's scope. Leaving either in-scope endpoint protection setting disabled does not satisfy the control.

The CIS 8.1.3.3 CLI and PowerShell audit only checks the `WDATP` setting. The policy also accepts `WDATP_UNIFIED_SOLUTION` because it controls the unified Microsoft Defender for Endpoint agent integration described in the control's notes, which is the current way to onboard servers to Defender for Endpoint.

The policy only runs when the Terraform plan contains an `azurerm_security_center_setting` resource for `WDATP` or `WDATP_UNIFIED_SOLUTION`. If neither setting is managed in the configuration, the policy does not evaluate anything, so it cannot detect that endpoint protection is turned off in the subscription.

This rule is covered by the [endpoint-protection-status-on](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/azure/security-center/endpoint-protection-status-on.policy.hcl) policy.

## Policy Results

```bash
trace:
	# endpoint-protection-status-on.policytest.hcl...
	running
	# resource.azurerm_security_center_setting.wdatp_enabled...
	running
	# resource.azurerm_security_center_setting.wdatp_enabled...
	pass
	# resource.azurerm_security_center_setting.wdatp_disabled...
	running
	# resource.azurerm_security_center_setting.wdatp_disabled...
	pass
	# resource.azurerm_security_center_setting.wdatp_unified_enabled...
	running
	# resource.azurerm_security_center_setting.wdatp_unified_enabled...
	pass
	# resource.azurerm_security_center_setting.wdatp_unified_disabled...
	running
	# resource.azurerm_security_center_setting.wdatp_unified_disabled...
	pass
	# resource.azurerm_security_center_setting.mcas_disabled...
	running
	# resource.azurerm_security_center_setting.mcas_disabled...
	pass
	# resource.azurerm_security_center_setting.sentinel_disabled...
	running
	# resource.azurerm_security_center_setting.sentinel_disabled...
	pass
	# resource.azurerm_security_center_setting.current_disabled...
	running
	# resource.azurerm_security_center_setting.current_disabled...
	pass
	# resource.azurerm_security_center_setting.setting_name_null_out_of_scope...
	running
	# resource.azurerm_security_center_setting.setting_name_null_out_of_scope...
	pass
	# endpoint-protection-status-on.policytest.hcl...
	pass
```

---
