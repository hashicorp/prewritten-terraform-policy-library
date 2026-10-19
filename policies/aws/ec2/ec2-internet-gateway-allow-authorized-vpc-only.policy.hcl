# Copyright IBM Corp. 2026

# Internet gateways should be attached only to authorized VPCs

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "ec2-internet-gateway-allow-authorized-vpc-only-enforcement-level" {
  type    = string
  default = "advisory"
}

input "ec2-internet-gateway-allow-authorized-vpc-only-authorized_vpc_ids" {
  type    = list(string)
  default = []
}

resource_policy "aws_internet_gateway" "allow_authorized_vpc_only" {
  filter = core::try(attrs.vpc_id, null) != null

  locals {
    vpc_id_raw      = core::try(attrs.vpc_id, null)
    vpc_id_set      = local.vpc_id_raw != null && local.vpc_id_raw != ""
    authorized_list = input.ec2-internet-gateway-allow-authorized-vpc-only-authorized_vpc_ids
    has_authorized  = core::length(local.authorized_list) > 0
    is_authorized   = local.vpc_id_set && local.has_authorized && core::contains(local.authorized_list, local.vpc_id_raw)
    vpc_id_display  = local.vpc_id_set ? local.vpc_id_raw : "undefined"
  }

  enforcement_level = input.ec2-internet-gateway-allow-authorized-vpc-only-enforcement-level
  enforce {
    condition     = local.is_authorized
    error_message = "Internet gateway is attached to unauthorized VPC '${local.vpc_id_display}'. Configure the 'authorized_vpc_ids' input with the list of authorized VPC IDs."
  }
}

resource_policy "aws_internet_gateway_attachment" "allow_authorized_vpc_only" {
  locals {
    vpc_id_raw      = core::try(attrs.vpc_id, null)
    vpc_id_set      = local.vpc_id_raw != null && local.vpc_id_raw != ""
    authorized_list = input.ec2-internet-gateway-allow-authorized-vpc-only-authorized_vpc_ids
    has_authorized  = core::length(local.authorized_list) > 0
    is_authorized   = local.vpc_id_set && local.has_authorized && core::contains(local.authorized_list, local.vpc_id_raw)
    vpc_id_display  = local.vpc_id_set ? local.vpc_id_raw : "undefined"
  }

  enforcement_level = input.ec2-internet-gateway-allow-authorized-vpc-only-enforcement-level
  enforce {
    condition     = local.is_authorized
    error_message = "Internet gateway attachment is attached to unauthorized VPC '${local.vpc_id_display}'. Configure the 'authorized_vpc_ids' input with the list of authorized VPC IDs."
  }
}
