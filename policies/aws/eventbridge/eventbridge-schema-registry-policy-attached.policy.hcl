# Copyright IBM Corp. 2026

# Custom EventBridge schema registries should have a resource policy attached

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "eventbridge-schema-registry-policy-attached-enforcement-level" {
  type    = string
  default = "advisory"
}

# This policy requires that AWS EventBridge Custom Schema Registries
# (aws_schemas_registry) have a resource policy (aws_schemas_registry_policy)
# attached, matched by registry name.
#
# Converted from Sentinel policy:
#   ./data/input-iso/sentinels/eventbridge-schema-registry-policy-attached.sentinel

locals {
  # Collect all planned aws_schemas_registry_policy resources (plan-time, top-level
  # lookup since the linking key -- registry_name -- is a known literal/stable attribute,
  # typically referencing another registry's `name` directly in config).
  schreg_all_registry_policies = core::getresources("aws_schemas_registry_policy", {})

  # Keep only policies that have both a non-empty registry_name and a non-empty policy
  # document -- mirrors the Sentinel helper get_registries_with_policies().
  schreg_qualifying_registry_policies = [for p in local.schreg_all_registry_policies : p
    if core::try(p.registry_name, null) != null
    && core::try(p.registry_name, "") != ""
    && core::try(p.policy, null) != null
  && core::try(p.policy, "") != ""]

  # Names of registries that have at least one qualifying resource policy attached.
  schreg_registry_names_with_policy = [for p in local.schreg_qualifying_registry_policies : core::try(p.registry_name, "")]
}

resource_policy "aws_schemas_registry" "policy_attached" {
  locals {
    registry_name_raw = core::try(attrs.name, null)
    registry_name     = local.registry_name_raw != null ? local.registry_name_raw : ""

    # Compliant only when the registry has a non-empty name AND that name
    # appears among registries that have a qualifying resource policy attached.
    is_compliant = local.registry_name != "" && core::contains(local.schreg_registry_names_with_policy, local.registry_name)
  }

  enforcement_level = input.eventbridge-schema-registry-policy-attached-enforcement-level
  enforce {
    condition     = local.is_compliant
    error_message = local.registry_name == "" ? "Custom Amazon EventBridge schema registries must have a resource policy attached. Registry name is undefined" : "Custom Amazon EventBridge schema registries must have a resource policy attached. Registry '${local.registry_name}' does not have a resource policy attached"
  }
}
