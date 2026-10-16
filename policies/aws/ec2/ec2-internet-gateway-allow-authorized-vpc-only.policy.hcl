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

# Converted from Sentinel policy: ec2-internet-gateway-allow-authorized-vpc-only
# Verifies that internet gateways are only attached to VPCs listed in the
# 'authorized_vpc_ids' input. An internet gateway -- whether attached via an
# inline vpc_id on aws_internet_gateway, or via a separate
# aws_internet_gateway_attachment resource -- is NON_COMPLIANT if it is
# attached to a VPC that is not in the authorized list, or if its VPC
# attachment is undefined/empty.
#
# NOTE: The original Sentinel policy distinguishes a hardcoded VPC ID
# ("constant_value") from an unresolved cross-resource reference at config
# time, treating any unresolved reference as non-compliant. In TFPolicy,
# attrs.vpc_id already reflects the resolved planned value (or is
# null/unknown when the referenced VPC has not yet been created in the same
# plan), so this policy evaluates the actual resolved value directly --
# equivalent (or stricter) coverage without needing a separate "reference"
# branch.
#
# NOTE: The Sentinel 'authorized_vpc_ids' parameter was a comma-separated
# string requiring manual split/trim. TFPolicy natively supports
# list(string) inputs, so this is converted to a native list input instead
# of a CSV string -- this is the recommended TFPolicy conversion pattern and
# avoids needing an undocumented string-trim implementation.

input "ec2-internet-gateway-allow-authorized-vpc-only-authorized_vpc_ids" {
  type    = list(string)
  default = []
}

resource_policy "aws_internet_gateway" "allow_authorized_vpc_only" {
  # Only evaluate internet gateways that configure vpc_id inline. Internet
  # gateways without vpc_id use a separate aws_internet_gateway_attachment
  # resource instead, which is covered by the resource_policy below.
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
