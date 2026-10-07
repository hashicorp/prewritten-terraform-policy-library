# Copyright IBM Corp. 2026

policytest {
  targets = ["defender-vm-os-updates.policy.hcl"]
}

# FAIL - Assignments that don't qualify do not cover the VMs.

# Assignment of a different policy definition.
resource "azurerm_subscription_policy_assignment" "other_definition_subscription" {
  skip = true
  attrs = {
    name                 = "other-definition-subscription"
    subscription_id      = "/subscriptions/00000000-0000-0000-0000-000000000000"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/f85bf3e0-d513-442e-89c3-1784ad63382b"
  }
}

# Assignment of bd876905 with enforce = false.
resource "azurerm_subscription_policy_assignment" "update_assessment_not_enforced" {
  skip = true
  attrs = {
    name                 = "update-assessment-not-enforced"
    subscription_id      = "/subscriptions/00000000-0000-0000-0000-000000000000"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/bd876905-5b84-4f73-ab2d-2e7a7c4568d9"
    enforce              = false
  }
}

# FAIL - no qualifying assignment and no periodic assessment.
resource "azurerm_linux_virtual_machine" "fail_linux_other_definition" {
  expect_failure = true
  attrs = {
    id                    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/vm-rg/providers/Microsoft.Compute/virtualMachines/vm-linux-nq"
    name                  = "vm-linux-nq"
    resource_group_name   = "vm-rg"
    location              = "eastus"
    size                  = "Standard_B2s"
    admin_username        = "azureuser"
  }
}

# FAIL - no qualifying assignment and no periodic assessment.
resource "azurerm_windows_virtual_machine" "fail_windows_other_definition" {
  expect_failure = true
  attrs = {
    id                    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/vm-rg/providers/Microsoft.Compute/virtualMachines/vm-win-nq"
    name                  = "vm-win-nq"
    resource_group_name   = "vm-rg"
    location              = "eastus"
    size                  = "Standard_B2s"
    admin_username        = "azureadmin"
    admin_password        = "P@ssw0rd1234!"
    patch_assessment_mode = "ImageDefault"
  }
}
