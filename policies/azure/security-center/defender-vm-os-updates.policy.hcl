# Copyright IBM Corp. 2026

# Ensure that Microsoft Defender for Cloud Checks VM Operating Systems for Updates

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "defender-vm-os-updates-enforcement-level" {
  type    = string
  default = "advisory"
}

locals {
  update_assessment_definition = "bd876905-5b84-4f73-ab2d-2e7a7c4568d9"

  update_assessment_subscription_assignments = [
    for a in core::getresources("azurerm_subscription_policy_assignment", {}) : a
    if core::contains_substring(core::lower(core::try(a.policy_definition_id, "")), local.update_assessment_definition) && core::try(a.enforce, true) != false
  ]
  update_assessment_mg_assignments = [
    for a in core::getresources("azurerm_management_group_policy_assignment", {}) : a
    if core::contains_substring(core::lower(core::try(a.policy_definition_id, "")), local.update_assessment_definition) && core::try(a.enforce, true) != false
  ]
  update_assessment_rg_assignments = [
    for a in core::getresources("azurerm_resource_group_policy_assignment", {}) : a
    if core::contains_substring(core::lower(core::try(a.policy_definition_id, "")), local.update_assessment_definition) && core::try(a.enforce, true) != false
  ]
  update_assessment_resource_assignments = [
    for a in core::getresources("azurerm_resource_policy_assignment", {}) : a
    if core::contains_substring(core::lower(core::try(a.policy_definition_id, "")), local.update_assessment_definition) && core::try(a.enforce, true) != false
  ]

  broad_update_assessment_assignment = core::length(local.update_assessment_subscription_assignments) + core::length(local.update_assessment_mg_assignments) > 0
}

resource_policy "azurerm_linux_virtual_machine" "linux_vm_periodic_update_assessment" {
  enforcement_level = input.defender-vm-os-updates-enforcement-level

  locals {
    vm_id_raw = core::try(attrs.id, null)
    vm_id     = local.vm_id_raw == null ? "" : core::lower(local.vm_id_raw)
    vm_rg_raw = core::try(attrs.resource_group_name, null)
    vm_rg     = local.vm_rg_raw == null ? "" : core::lower(local.vm_rg_raw)

    mode_raw                 = core::try(attrs.patch_assessment_mode, null)
    periodic_assessment_mode = local.mode_raw == "AutomaticByPlatform"

    rg_assignment_covers_vm = local.vm_rg != "" && core::length([
      for a in local.update_assessment_rg_assignments : a
      if core::contains_substring("${core::lower(core::try(a.resource_group_id, ""))}|", "/resourcegroups/${local.vm_rg}|")
    ]) > 0

    resource_assignment_covers_vm = local.vm_id != "" && core::length([
      for a in local.update_assessment_resource_assignments : a
      if core::lower(core::try(a.resource_id, "")) == local.vm_id
    ]) > 0

    covered_by_assignment = local.broad_update_assessment_assignment || local.rg_assignment_covers_vm || local.resource_assignment_covers_vm
  }

  enforce {
    condition     = local.periodic_assessment_mode || local.covered_by_assignment
    error_message = "Virtual machine must periodically check for missing system updates: set patch_assessment_mode = \"AutomaticByPlatform\", or assign Azure Policy bd876905-5b84-4f73-ab2d-2e7a7c4568d9 (Machines should be configured to periodically check for missing system updates) at a scope that covers the VM."
  }
}

resource_policy "azurerm_windows_virtual_machine" "windows_vm_periodic_update_assessment" {
  enforcement_level = input.defender-vm-os-updates-enforcement-level

  locals {
    vm_id_raw = core::try(attrs.id, null)
    vm_id     = local.vm_id_raw == null ? "" : core::lower(local.vm_id_raw)
    vm_rg_raw = core::try(attrs.resource_group_name, null)
    vm_rg     = local.vm_rg_raw == null ? "" : core::lower(local.vm_rg_raw)

    mode_raw                 = core::try(attrs.patch_assessment_mode, null)
    periodic_assessment_mode = local.mode_raw == "AutomaticByPlatform"

    rg_assignment_covers_vm = local.vm_rg != "" && core::length([
      for a in local.update_assessment_rg_assignments : a
      if core::contains_substring("${core::lower(core::try(a.resource_group_id, ""))}|", "/resourcegroups/${local.vm_rg}|")
    ]) > 0

    resource_assignment_covers_vm = local.vm_id != "" && core::length([
      for a in local.update_assessment_resource_assignments : a
      if core::lower(core::try(a.resource_id, "")) == local.vm_id
    ]) > 0

    covered_by_assignment = local.broad_update_assessment_assignment || local.rg_assignment_covers_vm || local.resource_assignment_covers_vm
  }

  enforce {
    condition     = local.periodic_assessment_mode || local.covered_by_assignment
    error_message = "Virtual machine must periodically check for missing system updates: set patch_assessment_mode = \"AutomaticByPlatform\", or assign Azure Policy bd876905-5b84-4f73-ab2d-2e7a7c4568d9 (Machines should be configured to periodically check for missing system updates) at a scope that covers the VM."
  }
}
