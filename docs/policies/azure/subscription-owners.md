# Ensure no more than 3 Subscription Owners are declared in the Terraform plan

| Provider | Category |
| -------- | -------- |
| Azure    | Identity and access management |

## Description

This control checks that the Terraform plan does not declare more than 3 Owner role assignments for an Azure subscription. Having at least two owners ensures redundancy and prevents a single point of failure for administrative access. Having no more than three owners reduces the risk of a compromised owner account and limits the blast radius of excessive privilege.

Subscription owners have full administrative control over all resources in the subscription. Assigning the Owner role to too few principals leaves the subscription at risk of being locked out if an owner account is compromised or unavailable. Assigning it to too many principals unnecessarily widens the attack surface.

**Enforcement note:** this policy enforces only the upper bound (no more than 3 Owners) from Terraform plan data. The minimum of 2 Owners cannot be reliably verified from a plan alone — a plan with zero visible Owner assignments does not prove the subscription has no Owners, since assignments made outside this Terraform configuration (Azure portal, CLI, other Terraform runs) are not visible to the plan. Maintain the minimum-Owner requirement through organizational process or a control with visibility into the live subscription state.

This rule is covered by the [subscription-owners](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/azure/iam/subscription-owners.policy.hcl) policy.

## Policy Results

```bash
trace:
	# subscription-owners.policytest.hcl...
	running
	# resource.azurerm_role_assignment.pass_minimum_two_owners...
	running
	# resource.azurerm_role_assignment.pass_minimum_two_owners...
	pass
	# resource.azurerm_role_assignment.pass_maximum_three_owners...
	running
	# resource.azurerm_role_assignment.pass_maximum_three_owners...
	pass
	# resource.azurerm_role_assignment.pass_below_minimum_not_enforced...
	running
	# resource.azurerm_role_assignment.pass_below_minimum_not_enforced...
	pass
	# resource.azurerm_role_assignment.fail_above_maximum...
	running
	# resource.azurerm_role_assignment.fail_above_maximum...
	pass
	# resource.azurerm_role_assignment.pass_non_owner_role...
	running
	# resource.azurerm_role_assignment.pass_non_owner_role...
	pass
	# resource.azurerm_role_assignment.pass_non_subscription_scope...
	running
	# resource.azurerm_role_assignment.pass_non_subscription_scope...
	pass
	# resource.azurerm_role_assignment.fail_uppercase_role_id_counts_as_owner...
	running
	# resource.azurerm_role_assignment.fail_uppercase_role_id_counts_as_owner...
	pass
	# subscription-owners.policytest.hcl...
	pass
```

---
