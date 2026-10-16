# Copyright IBM Corp. 2026

# Ensure that Azure Files SMB Protocol Versions are Restricted to SMB 3.1.1

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "storage-smb-protocol-version-311-required-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_storage_account" "smb_protocol_version_3_1_1" {
  filter = core::try(core::contains(["storagev2", "filestorage", "storage"], core::lower(attrs.account_kind)), true)

  locals {
    smb_versions_raw = core::try([for v in attrs.share_properties[0].smb[0].versions : v], [])
    smb_versions     = local.smb_versions_raw == null ? [] : local.smb_versions_raw
    non_311          = [for v in local.smb_versions : v if v != "SMB3.1.1"]
  }

  enforcement_level = input.storage-smb-protocol-version-311-required-enforcement-level
  enforce {
    condition     = core::length(local.smb_versions) > 0 && core::length(local.non_311) == 0
    error_message = "Storage account '${core::try(attrs.name, "unknown")}' must restrict share_properties.smb.versions to SMB3.1.1 only (absent means all SMB versions are allowed)."
  }
}
