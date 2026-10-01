# Copyright IBM Corp. 2026

policytest {
  targets = ["defender-vm-os-updates.policy.hcl"]
}

resource "azurerm_linux_virtual_machine" "pass_linux_automatic_by_platform" {
  attrs = {
    id                    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/vm-rg/providers/Microsoft.Compute/virtualMachines/vm-linux-pass"
    name                  = "vm-linux-pass"
    resource_group_name   = "vm-rg"
    location              = "eastus"
    size                  = "Standard_B2s"
    admin_username        = "azureuser"
    patch_assessment_mode = "AutomaticByPlatform"
  }
}

resource "azurerm_windows_virtual_machine" "pass_windows_automatic_by_platform" {
  attrs = {
    id                    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/vm-rg/providers/Microsoft.Compute/virtualMachines/vm-win-pass"
    name                  = "vm-win-pass"
    resource_group_name   = "vm-rg"
    location              = "eastus"
    size                  = "Standard_B2s"
    admin_username        = "azureadmin"
    admin_password        = "P@ssw0rd1234!"
    patch_assessment_mode = "AutomaticByPlatform"
  }
}

resource "azurerm_linux_virtual_machine" "fail_linux_image_default" {
  expect_failure = true
  attrs = {
    id                    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/vm-rg/providers/Microsoft.Compute/virtualMachines/vm-linux-default"
    name                  = "vm-linux-default"
    resource_group_name   = "vm-rg"
    location              = "eastus"
    size                  = "Standard_B2s"
    admin_username        = "azureuser"
    patch_assessment_mode = "ImageDefault"
  }
}

resource "azurerm_windows_virtual_machine" "fail_windows_image_default" {
  expect_failure = true
  attrs = {
    id                    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/vm-rg/providers/Microsoft.Compute/virtualMachines/vm-win-default"
    name                  = "vm-win-default"
    resource_group_name   = "vm-rg"
    location              = "eastus"
    size                  = "Standard_B2s"
    admin_username        = "azureadmin"
    admin_password        = "P@ssw0rd1234!"
    patch_assessment_mode = "ImageDefault"
  }
}

resource "azurerm_linux_virtual_machine" "fail_linux_mode_absent" {
  expect_failure = true
  attrs = {
    id                    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/vm-rg/providers/Microsoft.Compute/virtualMachines/vm-linux-absent"
    name                  = "vm-linux-absent"
    resource_group_name   = "vm-rg"
    location              = "eastus"
    size                  = "Standard_B2s"
    admin_username        = "azureuser"
  }
}

resource "azurerm_windows_virtual_machine" "fail_windows_mode_absent" {
  expect_failure = true
  attrs = {
    id                    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/vm-rg/providers/Microsoft.Compute/virtualMachines/vm-win-absent"
    name                  = "vm-win-absent"
    resource_group_name   = "vm-rg"
    location              = "eastus"
    size                  = "Standard_B2s"
    admin_username        = "azureadmin"
    admin_password        = "P@ssw0rd1234!"
  }
}
