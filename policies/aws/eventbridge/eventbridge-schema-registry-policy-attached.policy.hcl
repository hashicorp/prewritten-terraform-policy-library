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

locals {
  schreg_all_registry_policies = core::getresources("aws_schemas_registry_policy", {})

  schreg_qualifying_registry_policies = [for p in local.schreg_all_registry_policies : p
    if core::try(p.registry_name, null) != null
    && core::try(p.registry_name, "") != ""
    && core::try(p.policy, null) != null
  && core::try(p.policy, "") != ""]

  schreg_registry_names_with_policy = [for p in local.schreg_qualifying_registry_policies : core::try(p.registry_name, "")]
}

resource_policy "aws_schemas_registry" "policy_attached" {
  locals {
    registry_name_raw = core::try(attrs.name, null)
    registry_name     = local.registry_name_raw != null ? local.registry_name_raw : ""

    is_compliant = local.registry_name != "" && core::contains(local.schreg_registry_names_with_policy, local.registry_name)
  }

  enforcement_level = input.eventbridge-schema-registry-policy-attached-enforcement-level
  enforce {
    condition     = local.is_compliant
    error_message = local.registry_name == "" ? "Custom Amazon EventBridge schema registries must have a resource policy attached. Registry name is undefined" : "Custom Amazon EventBridge schema registries must have a resource policy attached. Registry '${local.registry_name}' does not have a resource policy attached"
  }
}
