# Copyright IBM Corp. 2026

policytest {
  targets = ["defender-vm-os-updates.policy.hcl"]
}

# PASS - The policy is assigned at subscription scope, so every VM is covered.

# Assignment of bd876905 at subscription scope.
resource "azurerm_subscription_policy_assignment" "update_assessment_subscription" {
  skip = true
  attrs = {
    name                 = "update-assessment-subscription"
    subscription_id      = "/subscriptions/00000000-0000-0000-0000-000000000000"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/bd876905-5b84-4f73-ab2d-2e7a7c4568d9"
  }
}

# PASS - covered by the subscription assignment.
resource "azurerm_linux_virtual_machine" "pass_linux_covered_by_subscription" {
  attrs = {
    id                    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/vm-rg/providers/Microsoft.Compute/virtualMachines/vm-linux-sub"
    name                  = "vm-linux-sub"
    resource_group_name   = "vm-rg"
    location              = "eastus"
    size                  = "Standard_B2s"
    admin_username        = "azureuser"
    patch_assessment_mode = "ImageDefault"
  }
}

# PASS - covered by the subscription assignment.
resource "azurerm_windows_virtual_machine" "pass_windows_covered_by_subscription" {
  attrs = {
    id                    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/vm-rg/providers/Microsoft.Compute/virtualMachines/vm-win-sub"
    name                  = "vm-win-sub"
    resource_group_name   = "vm-rg"
    location              = "eastus"
    size                  = "Standard_B2s"
    admin_username        = "azureadmin"
    admin_password        = "P@ssw0rd1234!"
  }
}
