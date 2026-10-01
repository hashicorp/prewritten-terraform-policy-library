# Copyright IBM Corp. 2026

policytest {
  targets = ["defender-vm-os-updates.policy.hcl"]
}

# PASS - The plan has no virtual machines, so the policy does not run.

resource "azurerm_security_center_subscription_pricing" "vm_plan_only" {
  skip = true
  attrs = {
    resource_type = "VirtualMachines"
    tier          = "Standard"
  }
}
