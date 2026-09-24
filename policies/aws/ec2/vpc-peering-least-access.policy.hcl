# Copyright IBM Corp. 2026

# Ensure routing tables for VPC peering are "least access" (CIS 5.5)

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "vpc-peering-least-access-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_route" "vpc_peering_least_access" {
  enforcement_level = input.vpc-peering-least-access-enforcement-level

  locals {
    peering_id       = core::try(attrs.vpc_peering_connection_id, "")
    is_peering_route = local.peering_id != "" && local.peering_id != null

    dest_cidr     = core::try(attrs.destination_cidr_block, "")
    dest_ipv6     = core::try(attrs.destination_ipv6_cidr_block, "")

    is_overly_permissive = local.dest_cidr == "0.0.0.0/0" || local.dest_ipv6 == "::/0"
  }

  filter = local.is_peering_route

  enforce {
    condition     = !local.is_overly_permissive
    error_message = "Route with vpc_peering_connection_id must not use a catch-all CIDR (0.0.0.0/0 or ::/0). Use the most specific CIDR block needed to comply with CIS 5.5 least-access principle."
  }
}

