# Copyright IBM Corp. 2026

# EC2 instances should belong to a VPC

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "ec2-belong-to-vpc-enforcement-level" {
  type    = string
  default = "advisory"
}

input "ec2-belong-to-vpc-vpc_id" {
  type        = string
  default     = ""
  description = "Optional VPC ID. When set, instances using subnet_id must reference a subnet belonging to this VPC. Empty string (default) accepts any VPC."
}

resource_policy "aws_instance" "belongs_to_vpc" {
  locals {
    vpc_id_param = input.ec2-belong-to-vpc-vpc_id

    subnet_id_raw = core::try(attrs.subnet_id, null)
    has_subnet_id = local.subnet_id_raw != null && local.subnet_id_raw != ""

    vpc_sg_raw = core::try(attrs.vpc_security_group_ids, null)
    has_vpc_sg = local.vpc_sg_raw != null ? core::length(local.vpc_sg_raw) > 0 : false

    pni_raw       = core::try(attrs.primary_network_interface, null)
    has_pni       = local.pni_raw != null ? core::length(local.pni_raw) > 0 : false
    pni_ni_id_raw = local.has_pni ? core::try(local.pni_raw[0].network_interface_id, null) : null
    pni_ni_id     = local.pni_ni_id_raw != null ? local.pni_ni_id_raw : ""

    subnet_lookup      = local.has_subnet_id ? core::getresources("aws_subnet", { id = local.subnet_id_raw }) : []
    subnet_found       = core::length(local.subnet_lookup) > 0
    subnet_vpc_id      = local.subnet_found ? core::try(local.subnet_lookup[0].vpc_id, "") : ""
    subnet_vpc_matches = local.vpc_id_param == "" || !local.subnet_found || local.subnet_vpc_id == local.vpc_id_param

    ni_lookup        = local.pni_ni_id != "" ? core::getresources("aws_network_interface", { id = local.pni_ni_id }) : []
    ni_found         = core::length(local.ni_lookup) > 0
    ni_subnet_raw    = local.ni_found ? core::try(local.ni_lookup[0].subnet_id, null) : null
    ni_has_subnet    = local.ni_subnet_raw != null && local.ni_subnet_raw != ""
    primary_ni_valid = local.has_pni && local.pni_ni_id != "" && local.ni_has_subnet

    is_compliant = local.has_subnet_id ? local.subnet_vpc_matches : (local.has_vpc_sg ? true : (local.has_pni ? local.primary_ni_valid : false))
  }

  enforcement_level = input.ec2-belong-to-vpc-enforcement-level
  enforce {
    condition     = local.is_compliant
    error_message = "EC2 instance must belong to a VPC. Configure subnet_id (in the required VPC, if a vpc_id is specified), vpc_security_group_ids, or a primary_network_interface that references an aws_network_interface with a configured subnet_id."
  }
}
