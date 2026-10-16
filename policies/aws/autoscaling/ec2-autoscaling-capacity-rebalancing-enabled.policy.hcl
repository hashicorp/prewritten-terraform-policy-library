# Copyright IBM Corp. 2026

# Auto Scaling groups with multiple instance types should have Capacity Rebalancing enabled

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

# Converted from Sentinel policy: ec2-autoscaling-capacity-rebalancing-enabled
# This policy requires that Capacity Rebalancing is enabled for Amazon EC2 Auto Scaling groups
# that use multiple instance types.
# Refer to https://docs.aws.amazon.com/config/latest/developerguide/autoscaling-capacity-rebalancing.html
input "ec2-autoscaling-capacity-rebalancing-enabled-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_autoscaling_group" "ec2_autoscaling_capacity_rebalancing_enabled" {
  locals {
    # mixed_instances_policy is a nesting_mode=list block (max 1 item in HCL),
    # but is represented as a list in planned values.
    mixed_instances_policy_raw = core::try(attrs.mixed_instances_policy, null)
    mixed_instances_policy     = local.mixed_instances_policy_raw != null ? local.mixed_instances_policy_raw : []
    has_mixed_instances_policy = core::length(local.mixed_instances_policy) > 0

    launch_template_raw = local.has_mixed_instances_policy ? core::try(local.mixed_instances_policy[0].launch_template, null) : null
    launch_template     = local.launch_template_raw != null ? local.launch_template_raw : []
    has_launch_template = core::length(local.launch_template) > 0

    overrides_raw  = local.has_launch_template ? core::try(local.launch_template[0].override, null) : null
    overrides      = local.overrides_raw != null ? local.overrides_raw : []
    override_count = core::length(local.overrides)

    # Attribute-based instance selection (instance_requirements) can resolve to multiple
    # instance types even with a single override entry.
    # NOTE: instance_requirements may be preflighted/mocked as an explicit `null`
    # (not merely absent), so core::try() alone does not fall back to a default here.
    # Normalize explicitly with the two-step pattern before measuring length.
    overrides_requirements_lengths = [
      for o in local.overrides :
      core::length(core::try(o.instance_requirements, null) == null ? [] : core::try(o.instance_requirements, null))
    ]
    has_instance_requirements_override = core::length([
      for l in local.overrides_requirements_lengths : l if l > 0
    ]) > 0

    # Multiple instance types are in use if any override specifies instance_requirements,
    # or if there is more than one override entry.
    has_multiple_instance_types = local.has_instance_requirements_override || local.override_count > 1

    capacity_rebalance_raw = core::try(attrs.capacity_rebalance, null)
    capacity_rebalance     = local.capacity_rebalance_raw == null ? false : local.capacity_rebalance_raw

    # Compliant when the ASG does not use multiple instance types, OR when it does and
    # capacity_rebalance is enabled.
    is_compliant = !local.has_multiple_instance_types || local.capacity_rebalance == true
  }

  enforcement_level = input.ec2-autoscaling-capacity-rebalancing-enabled-enforcement-level
  enforce {
    condition     = local.is_compliant
    error_message = "Capacity Rebalancing must be enabled (capacity_rebalance = true) for Auto Scaling groups that use multiple instance types"
  }
}
