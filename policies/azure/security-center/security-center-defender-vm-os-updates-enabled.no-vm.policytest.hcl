# Copyright IBM Corp. 2026

policytest {
  targets = ["security-center-defender-vm-os-updates-enabled.policy.hcl"]
}

# PASS - The plan has no virtual machines, so the policy does not run.

resource "azurerm_security_center_subscription_pricing" "vm_plan_only" {
  skip = true
  attrs = {
    resource_type = "VirtualMachines"
    tier          = "Standard"
  }
}
