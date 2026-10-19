# Copyright IBM Corp. 2026

# RDS DB instances should not be deployed in public subnets with routes to internet gateways

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "rds-instance-subnet-igw-check-enforcement-level" {
  type    = string
  default = "advisory"
}

# GAP: This policy cannot be fully converted to the new relationship syntax.
#
# It performs a five-hop join:
#   aws_db_instance
#     → aws_db_subnet_group (by db_subnet_group_name / name)
#     → aws_subnet (by subnet_ids list membership / id)
#     → aws_route_table_association / aws_main_route_table_association (by subnet_id)
#     → aws_route_table (by route_table_id)
#
# Multiple gaps apply simultaneously:
# 1. List membership: subnet_ids is a list on aws_db_subnet_group; the connection
#    model requires scalar attribute equality, not "subject value in target list".
# 2. Multi-hop: the route table lookup requires chaining through three more
#    intermediate resources after the subnet group. No multi-hop mechanism exists.
# 3. Two alternative route table lookups (explicit association + main association)
#    joined by OR cannot be expressed in a single connected block.

resource_policy "aws_db_instance" "no_public_subnet_igw" {
  enforcement_level = input.rds-instance-subnet-igw-check-enforcement-level

  locals {
    subnet_group_name    = core::try(attrs.db_subnet_group_name, "")
    all_db_subnet_groups = core::getresources("aws_db_subnet_group", {})

    db_subnet_groups = local.subnet_group_name != "" ? [
      for sg in local.all_db_subnet_groups :
      sg if core::try(sg.name, "") == local.subnet_group_name
    ] : []

    db_subnet_group  = core::length(local.db_subnet_groups) > 0 ? local.db_subnet_groups[0] : null
    subnet_ids       = core::try(local.db_subnet_group.subnet_ids, [])
    can_evaluate     = local.subnet_group_name != "" && core::length(local.subnet_ids) > 0

    all_subnets = core::getresources("aws_subnet", {})
    db_subnets  = [for s in local.all_subnets : s if core::contains(local.subnet_ids, core::try(s.id, ""))]

    all_associations = core::getresources("aws_route_table_association", {})
    explicit_associations = [for assoc in local.all_associations : assoc if core::contains(local.subnet_ids, core::try(assoc.subnet_id, ""))]
    explicit_route_table_ids = [for assoc in local.explicit_associations : core::try(assoc.route_table_id, "") if core::try(assoc.route_table_id, "") != ""]

    all_main_associations = core::getresources("aws_main_route_table_association", {})
    implicit_main_route_table_ids = [
      for subnet in local.db_subnets :
      core::try([
        for main_assoc in local.all_main_associations :
        core::try(main_assoc.route_table_id, "")
        if core::try(main_assoc.vpc_id, "") == core::try(subnet.vpc_id, "")
      ][0], "")
      if core::length([for assoc in local.explicit_associations : assoc if core::try(assoc.subnet_id, "") == core::try(subnet.id, "")]) == 0
    ]

    effective_route_table_ids = core::distinct(core::concat(local.explicit_route_table_ids, local.implicit_main_route_table_ids))

    all_route_tables = core::getresources("aws_route_table", {})
    route_tables_with_igw = [
      for rt in local.all_route_tables :
      rt if (
        core::contains(local.effective_route_table_ids, core::try(rt.id, "")) &&
        core::length([
          for route in core::try(rt.route, []) :
          route if (
            (core::try(route.cidr_block, "") == "0.0.0.0/0" || core::try(route.ipv6_cidr_block, "") == "::/0") &&
            core::length(core::regexall("^igw-", core::try(route.gateway_id, ""))) > 0
          )
        ]) > 0
      )
    ]

    has_igw_route = core::length(local.route_tables_with_igw) > 0
  }

  enforce {
    condition     = local.can_evaluate && !local.has_igw_route
    error_message = "RDS DB instance must use a resolvable DB subnet group whose subnets do not have default routes to an Internet Gateway. Unresolved subnet groups and public subnet routing are noncompliant"
  }
}
