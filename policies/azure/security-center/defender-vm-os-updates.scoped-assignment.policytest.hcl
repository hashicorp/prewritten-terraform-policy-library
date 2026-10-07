# Copyright IBM Corp. 2026

policytest {
  targets = ["defender-vm-os-updates.policy.hcl"]
}

# Assignments scoped to one resource group and one VM only cover those targets.

# Assignment of bd876905 on resource group covered-rg.
resource "azurerm_resource_group_policy_assignment" "update_assessment_rg" {
  skip = true
  attrs = {
    name                 = "update-assessment-rg"
    resource_group_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/covered-rg"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/bd876905-5b84-4f73-ab2d-2e7a7c4568d9"
  }
}

# Assignment of bd876905 on VM vm-win-res only.
resource "azurerm_resource_policy_assignment" "update_assessment_vm" {
  skip = true
  attrs = {
    name                 = "update-assessment-vm"
    resource_id          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/vm-rg/providers/Microsoft.Compute/virtualMachines/vm-win-res"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/bd876905-5b84-4f73-ab2d-2e7a7c4568d9"
  }
}

# PASS - VM is in the assigned resource group.
resource "azurerm_linux_virtual_machine" "pass_linux_in_assigned_rg" {
  attrs = {
    id                    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/covered-rg/providers/Microsoft.Compute/virtualMachines/vm-linux-rg"
    name                  = "vm-linux-rg"
    resource_group_name   = "covered-rg"
    location              = "eastus"
    size                  = "Standard_B2s"
    admin_username        = "azureuser"
  }
}

# PASS - policy is assigned directly to this VM.
resource "azurerm_windows_virtual_machine" "pass_windows_assigned_directly" {
  attrs = {
    id                    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/vm-rg/providers/Microsoft.Compute/virtualMachines/vm-win-res"
    name                  = "vm-win-res"
    resource_group_name   = "vm-rg"
    location              = "eastus"
    size                  = "Standard_B2s"
    admin_username        = "azureadmin"
    admin_password        = "P@ssw0rd1234!"
  }
}

# FAIL - VM is outside the assigned resource group and VM.
resource "azurerm_linux_virtual_machine" "fail_linux_other_rg" {
  expect_failure = true
  attrs = {
    id                    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/other-rg/providers/Microsoft.Compute/virtualMachines/vm-linux-other"
    name                  = "vm-linux-other"
    resource_group_name   = "other-rg"
    location              = "eastus"
    size                  = "Standard_B2s"
    admin_username        = "azureuser"
  }
}

# FAIL - resource group 'covered' must not match the assignment on 'covered-rg'.
resource "azurerm_linux_virtual_machine" "fail_linux_rg_name_prefix" {
  expect_failure = true
  attrs = {
    id                    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/covered/providers/Microsoft.Compute/virtualMachines/vm-linux-prefix"
    name                  = "vm-linux-prefix"
    resource_group_name   = "covered"
    location              = "eastus"
    size                  = "Standard_B2s"
    admin_username        = "azureuser"
  }
}
