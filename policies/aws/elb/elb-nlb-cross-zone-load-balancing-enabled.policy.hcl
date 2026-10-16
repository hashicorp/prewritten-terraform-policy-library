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

resource_policy "aws_lb" "elb_nlb_cross_zone_load_balancing_enabled" {
  locals {
    load_balancer_type_raw   = core::try(attrs.load_balancer_type, null)
    load_balancer_type       = local.load_balancer_type_raw != null ? local.load_balancer_type_raw : "application"
    is_network_load_balancer = local.load_balancer_type == "network"

    cross_zone_raw     = core::try(attrs.enable_cross_zone_load_balancing, null)
    cross_zone_enabled = local.cross_zone_raw == null ? false : local.cross_zone_raw

    lb_name = core::try(attrs.name, "unknown")
  }

  filter = local.is_network_load_balancer

  enforcement_level = input.elb-nlb-cross-zone-load-balancing-enabled-enforcement-level
  enforce {
    condition     = local.cross_zone_enabled == true
    error_message = "Network Load Balancer '${local.lb_name}' does not have 'enable_cross_zone_load_balancing' set to true. Cross-zone load balancing must be enabled for Network Load Balancers."
  }
}
