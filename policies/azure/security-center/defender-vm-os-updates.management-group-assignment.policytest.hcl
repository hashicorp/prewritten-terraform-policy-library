# Copyright IBM Corp. 2026

policytest {
  targets = ["defender-vm-os-updates.policy.hcl"]
}

# PASS - The policy is assigned at management group scope.

# Assignment of bd876905 at management group scope.
resource "azurerm_management_group_policy_assignment" "update_assessment_management_group" {
  skip = true
  attrs = {
    name                 = "update-assessment-management-group"
    management_group_id  = "/providers/Microsoft.Management/managementGroups/platform"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/bd876905-5b84-4f73-ab2d-2e7a7c4568d9"
  }
}

# PASS - covered by the management group assignment.
resource "azurerm_linux_virtual_machine" "pass_linux_covered_by_management_group" {
  attrs = {
    id                    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/vm-rg/providers/Microsoft.Compute/virtualMachines/vm-linux-mg"
    name                  = "vm-linux-mg"
    resource_group_name   = "vm-rg"
    location              = "eastus"
    size                  = "Standard_B2s"
    admin_username        = "azureuser"
  }
}
