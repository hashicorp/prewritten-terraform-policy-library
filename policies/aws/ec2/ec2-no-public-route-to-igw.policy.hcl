# Copyright IBM Corp. 2026

# Route tables should not have unrestricted routes to an internet gateway

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "ec2-no-public-route-to-igw-enforcement-level" {
  type    = string
  default = "advisory"
}

input "ec2-no-public-route-to-igw-allowed_route_table_ids" {
  type    = list(string)
  default = []
}

resource_policy "aws_route_table" "no_public_route_to_igw" {
  locals {
    routes_raw = core::try(attrs.route, null)
    routes     = local.routes_raw != null ? local.routes_raw : []

    route_table_id = core::try(attrs.id, "")
    is_allowed     = core::length(input.ec2-no-public-route-to-igw-allowed_route_table_ids) == 0 ? false : core::contains(input.ec2-no-public-route-to-igw-allowed_route_table_ids, local.route_table_id)

    normalized_routes = [for r in local.routes : {
      gateway_id      = core::try(r.gateway_id, null) != null ? core::try(r.gateway_id, null) : ""
      cidr_block      = core::try(r.cidr_block, null) != null ? core::try(r.cidr_block, null) : ""
      ipv6_cidr_block = core::try(r.ipv6_cidr_block, null) != null ? core::try(r.ipv6_cidr_block, null) : ""
    }]

    public_igw_routes = [for r in local.normalized_routes : r
      if r.gateway_id != "" &&
      core::startswith(r.gateway_id, "igw-") &&
    (r.cidr_block == "0.0.0.0/0" || r.ipv6_cidr_block == "::/0")]

    has_public_igw_route = core::length(local.public_igw_routes) > 0
  }

  enforcement_level = input.ec2-no-public-route-to-igw-enforcement-level
  enforce {
    condition     = local.is_allowed || !local.has_public_igw_route
    error_message = "Route table '${local.route_table_id}' contains routes with unrestricted access (0.0.0.0/0 or ::/0) to an Internet Gateway. This creates public routes with unrestricted access"
  }
}

resource_policy "aws_route" "no_public_route_to_igw" {
  locals {
    route_table_id      = core::try(attrs.route_table_id, null) != null ? attrs.route_table_id : ""
    is_allowed          = core::length(input.ec2-no-public-route-to-igw-allowed_route_table_ids) == 0 ? false : core::contains(input.ec2-no-public-route-to-igw-allowed_route_table_ids, local.route_table_id)
    gateway_id          = core::try(attrs.gateway_id, null) != null ? attrs.gateway_id : ""
    cidr_block          = core::try(attrs.destination_cidr_block, null) != null ? attrs.destination_cidr_block : ""
    ipv6_cidr_block     = core::try(attrs.destination_ipv6_cidr_block, null) != null ? attrs.destination_ipv6_cidr_block : ""
    is_public_igw_route = core::startswith(local.gateway_id, "igw-") && (local.cidr_block == "0.0.0.0/0" || local.ipv6_cidr_block == "::/0")
  }

  enforcement_level = input.ec2-no-public-route-to-igw-enforcement-level

  enforce {
    condition     = local.is_allowed || !local.is_public_igw_route
    error_message = "Route '${local.route_table_id}' sends unrestricted traffic (0.0.0.0/0 or ::/0) to an Internet Gateway. This creates a public route with unrestricted access"
  }
}
