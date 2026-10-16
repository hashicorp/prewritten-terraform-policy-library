# Copyright IBM Corp. 2026

# EC2 instances should belong to a VPC

# EC2 Instance Belongs to a VPC
#
# (https://docs.aws.amazon.com/config/latest/developerguide/ec2-instances-in-vpc.html).
#
# Verifies that every aws_instance belongs to a Virtual Private Cloud (VPC) by
# requiring one of the following VPC-indicating configurations, checked in the
# same priority order as the original Sentinel logic:
#   1. subnet_id is set. If the optional `vpc_id` input is provided, the
#      referenced aws_subnet (when resolvable in the same plan) must belong
#      to that VPC.
#   2. vpc_security_group_ids is set (a VPC-only attribute, so its presence
#      indicates VPC membership).
#   3. primary_network_interface is set and references an aws_network_interface
#      that itself has subnet_id configured.
#   Otherwise the instance is reported as not belonging to a VPC.
#
# Resources checked:
# - aws_instance (primary enforcement target)
# - aws_subnet (cross-resource lookup to verify VPC membership of a referenced subnet)
# - aws_network_interface (cross-resource lookup to verify a referenced ENI has a subnet)
#
# NOTE: The subnet and network-interface lookups use aws_instance's own
# attributes (subnet_id / primary_network_interface[0].network_interface_id) as
# the filter value for an inline core::getresources() call. This policy
# contains a cross-resource reference that will not resolve during plan time
# when the referenced subnet/ENI is created in the same plan (its id is not
# yet known), but the policy will run successfully during apply time and on
# plans against existing infrastructure. The two lookups intentionally mirror
# the ORIGINAL Sentinel's distinct fallback behaviors when the referenced
# resource cannot be resolved (not found in the plan):
#   - subnet lookup not found  -> treated as compliant/cannot-verify (matches
#     check_subnet_vpc's "return true" when no matching subnet config exists).
#   - network-interface lookup not found -> treated as non-compliant (matches
#     check_network_interface_has_subnet's "return false" when no matching
#     network interface config exists).
#
# LIMITATION: The Sentinel source also treats the deprecated aws_instance
# `network_interface` block as sufficient evidence of VPC membership (kept
# only for backward compatibility in the original policy). Because
# `network_interface` is marked deprecated in the AWS provider schema with a
# documented replacement (`primary_network_interface` for the primary
# interface, `aws_network_interface_attachment` for additional interfaces),
# this branch is intentionally NOT implemented here, per the rule that a
# deprecated attribute with an available replacement must not be used in a
# generated policy. Instances that configure ONLY the deprecated
# `network_interface` block (and none of subnet_id, vpc_security_group_ids, or
# a valid primary_network_interface) will be reported as non-compliant by this
# policy, even though the original Sentinel policy treated them as compliant.
# Migrate such instances to `primary_network_interface` (and
# `aws_network_interface_attachment` for secondary interfaces) to remain
# compliant.
#
# The Sentinel source also inspected a top-level `network_interface_id`
# attribute (`config.network_interface_id`) directly on aws_instance. This
# attribute does not exist in the current AWS provider schema — confirmed via
# `terraform validate`, which returns "Unsupported argument" for it — so it
# has been omitted here. Its intended replacement,
# `primary_network_interface.network_interface_id`, IS implemented below.

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
    # Ternary guard: && does not short-circuit in TFPolicy locals, so core::length()
    # must not be called directly on a value that may be null.
    has_vpc_sg = local.vpc_sg_raw != null ? core::length(local.vpc_sg_raw) > 0 : false

    pni_raw = core::try(attrs.primary_network_interface, null)
    # Ternary guard: same reasoning as has_vpc_sg above.
    has_pni       = local.pni_raw != null ? core::length(local.pni_raw) > 0 : false
    pni_ni_id_raw = local.has_pni ? core::try(local.pni_raw[0].network_interface_id, null) : null
    pni_ni_id     = local.pni_ni_id_raw != null ? local.pni_ni_id_raw : ""

    # Cross-resource lookup: subnet referenced by subnet_id (apply-time pattern - see header NOTE)
    subnet_lookup = local.has_subnet_id ? core::getresources("aws_subnet", { id = local.subnet_id_raw }) : []
    subnet_found  = core::length(local.subnet_lookup) > 0
    subnet_vpc_id = local.subnet_found ? core::try(local.subnet_lookup[0].vpc_id, "") : ""
    # Compliant when: no vpc_id input configured, OR the subnet could not be resolved (cannot verify, matches Sentinel fallback), OR the subnet's vpc_id matches the required value
    subnet_vpc_matches = local.vpc_id_param == "" || !local.subnet_found || local.subnet_vpc_id == local.vpc_id_param

    # Cross-resource lookup: network interface referenced by primary_network_interface (apply-time pattern - see header NOTE)
    ni_lookup        = local.pni_ni_id != "" ? core::getresources("aws_network_interface", { id = local.pni_ni_id }) : []
    ni_found         = core::length(local.ni_lookup) > 0
    ni_subnet_raw    = local.ni_found ? core::try(local.ni_lookup[0].subnet_id, null) : null
    ni_has_subnet    = local.ni_subnet_raw != null && local.ni_subnet_raw != ""
    primary_ni_valid = local.has_pni && local.pni_ni_id != "" && local.ni_has_subnet

    # Priority order mirrors the original Sentinel logic: subnet_id > vpc_security_group_ids > primary_network_interface > none
    is_compliant = local.has_subnet_id ? local.subnet_vpc_matches : (local.has_vpc_sg ? true : (local.has_pni ? local.primary_ni_valid : false))
  }

  enforcement_level = input.ec2-belong-to-vpc-enforcement-level
  enforce {
    condition     = local.is_compliant
    error_message = "EC2 instance must belong to a VPC. Configure subnet_id (in the required VPC, if a vpc_id is specified), vpc_security_group_ids, or a primary_network_interface that references an aws_network_interface with a configured subnet_id."
  }
}
