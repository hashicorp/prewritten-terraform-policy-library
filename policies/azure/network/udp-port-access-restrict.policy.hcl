# Copyright IBM Corp. 2026

# Ensure that UDP Port Access from the Internet is Evaluated and Restricted

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

resource_policy "azurerm_network_security_group" "restrict_internet_udp_ports" {
  locals {
    restricted_ports        = [53, 123, 161, 389, 1900]
    restricted_port_strings = ["53", "123", "161", "389", "1900"]
    security_rules_raw      = core::try(attrs.security_rule, null)
    security_rules          = local.security_rules_raw != null ? local.security_rules_raw : []
    inbound_udp_allow_rules = [for rule in local.security_rules : rule if core::try(rule.direction, "") == "Inbound" && core::try(rule.access, "") == "Allow" && (core::try(rule.protocol, "") == "Udp" || core::try(rule.protocol, "") == "*")]
    internet_exposed_rules  = [for rule in local.inbound_udp_allow_rules : rule if core::contains(["0.0.0.0/0", "Internet", "*"], core::try(rule.source_address_prefix, null) != null ? core::try(rule.source_address_prefix, "") : "") || core::length([for prefix in (core::try(rule.source_address_prefixes, null) != null ? core::try(rule.source_address_prefixes, []) : []) : prefix if core::contains(["0.0.0.0/0", "Internet", "*"], prefix)]) > 0]
    violating_rules         = [for rule in local.internet_exposed_rules : rule if (core::try(rule.destination_port_range, null) != null ? core::try(rule.destination_port_range, "") : "") == "*" || core::contains(local.restricted_port_strings, core::try(rule.destination_port_range, null) != null ? core::try(rule.destination_port_range, "") : "") || core::length([for restricted_port in local.restricted_ports : restricted_port if core::try(core::parseint(core::try(core::split("-", core::try(rule.destination_port_range, ""))[0], ""), 10), -1) <= restricted_port && core::try(core::parseint(core::try(core::split("-", core::try(rule.destination_port_range, ""))[1], ""), 10), -1) >= restricted_port]) > 0 || core::length([for port_spec in (core::try(rule.destination_port_ranges, null) != null ? core::try(rule.destination_port_ranges, []) : []) : port_spec if port_spec == "*" || core::contains(local.restricted_port_strings, port_spec) || core::length([for restricted_port in local.restricted_ports : restricted_port if core::try(core::parseint(core::try(core::split("-", port_spec)[0], ""), 10), -1) <= restricted_port && core::try(core::parseint(core::try(core::split("-", port_spec)[1], ""), 10), -1) >= restricted_port]) > 0]) > 0]
  }

  enforcement_level = "advisory"
  enforce {
    condition     = core::length(local.violating_rules) == 0
    error_message = "Network security group rules must not allow Internet-level UDP access to ports 53, 123, 161, 389, or 1900. Remove the rule or restrict its protocol, source, destination ports, or access."
  }
}
