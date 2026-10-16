# Copyright IBM Corp. 2026

# Network Load Balancers should have cross-zone load balancing enabled

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "elb-nlb-cross-zone-load-balancing-enabled-enforcement-level" {
  type    = string
  default = "advisory"
}

# This policy verifies that cross-zone load balancing is enabled on Network Load Balancers (NLBs).
# Converted from Sentinel policy: elb-nlb-cross-zone-load-balancing-enabled.sentinel
resource_policy "aws_lb" "elb_nlb_cross_zone_load_balancing_enabled" {
  locals {
    # Default load_balancer_type to "application" when not explicitly set, matching Sentinel's
    # maps.get(res.values, "load_balancer_type", "application") behavior.
    load_balancer_type_raw   = core::try(attrs.load_balancer_type, null)
    load_balancer_type       = local.load_balancer_type_raw != null ? local.load_balancer_type_raw : "application"
    is_network_load_balancer = local.load_balancer_type == "network"

    # Default enable_cross_zone_load_balancing to false when not explicitly set, matching
    # Sentinel's maps.get(res.values, "enable_cross_zone_load_balancing", false) behavior.
    cross_zone_raw     = core::try(attrs.enable_cross_zone_load_balancing, null)
    cross_zone_enabled = local.cross_zone_raw == null ? false : local.cross_zone_raw

    lb_name = core::try(attrs.name, "unknown")
  }

  # Only evaluate Network Load Balancers; Application and Gateway Load Balancers are out of scope.
  filter = local.is_network_load_balancer

  enforcement_level = input.elb-nlb-cross-zone-load-balancing-enabled-enforcement-level
  enforce {
    condition     = local.cross_zone_enabled == true
    error_message = "Network Load Balancer '${local.lb_name}' does not have 'enable_cross_zone_load_balancing' set to true. Cross-zone load balancing must be enabled for Network Load Balancers."
  }
}
