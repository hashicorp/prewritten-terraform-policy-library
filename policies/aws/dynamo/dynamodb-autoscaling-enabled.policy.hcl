# Copyright IBM Corp. 2026

# DynamoDB tables should automatically scale capacity with demand

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "dynamodb-autoscaling-enabled-enforcement-level" {
  type    = string
  default = "advisory"
}

input "minProvisionedReadCapacity" {
  type    = number
  default = 0
}

input "maxProvisionedReadCapacity" {
  type    = number
  default = 0
}

input "targetReadUtilization" {
  type    = number
  default = 0
}

input "minProvisionedWriteCapacity" {
  type    = number
  default = 0
}

input "maxProvisionedWriteCapacity" {
  type    = number
  default = 0
}

input "targetWriteUtilization" {
  type    = number
  default = 0
}

resource_policy "aws_dynamodb_table" "autoscaling_enabled" {
  enforcement_level = input.dynamodb-autoscaling-enabled-enforcement-level

  # PAY_PER_REQUEST tables scale automatically and do not require
  # Application Auto Scaling targets.
  filter = core::try(attrs.billing_mode, "PROVISIONED") != "PAY_PER_REQUEST"

  locals {
    table_name = core::try(attrs.name, "")

    matching_autoscaling_targets = core::getresources("aws_appautoscaling_target", {
      service_namespace = "dynamodb"
      resource_id       = "table/${local.table_name}"
    })

    read_autoscaling_targets = [
      for target in local.matching_autoscaling_targets : target
      if core::try(target.scalable_dimension, "") == "dynamodb:table:ReadCapacityUnits"
    ]

    write_autoscaling_targets = [
      for target in local.matching_autoscaling_targets : target
      if core::try(target.scalable_dimension, "") == "dynamodb:table:WriteCapacityUnits"
    ]

    has_read_autoscaling_target = core::length(local.read_autoscaling_targets) > 0
    has_write_autoscaling_target = core::length(local.write_autoscaling_targets) > 0

    read_autoscaling_target = local.has_read_autoscaling_target ? local.read_autoscaling_targets[0] : null
    write_autoscaling_target = local.has_write_autoscaling_target ? local.write_autoscaling_targets[0] : null

    matching_autoscaling_policies = core::getresources("aws_appautoscaling_policy", {
      service_namespace = "dynamodb"
      resource_id       = "table/${local.table_name}"
    })

    read_autoscaling_policies = [
      for policy in local.matching_autoscaling_policies : policy
      if core::try(policy.scalable_dimension, "") == "dynamodb:table:ReadCapacityUnits" &&
         core::try(policy.policy_type, "") == "TargetTrackingScaling"
    ]

    write_autoscaling_policies = [
      for policy in local.matching_autoscaling_policies : policy
      if core::try(policy.scalable_dimension, "") == "dynamodb:table:WriteCapacityUnits" &&
         core::try(policy.policy_type, "") == "TargetTrackingScaling"
    ]

    has_read_autoscaling_policy = core::length(local.read_autoscaling_policies) > 0
    has_write_autoscaling_policy = core::length(local.write_autoscaling_policies) > 0

    read_autoscaling_policy = local.has_read_autoscaling_policy ? local.read_autoscaling_policies[0] : null
    write_autoscaling_policy = local.has_write_autoscaling_policy ? local.write_autoscaling_policies[0] : null

    actual_min_read_capacity = core::try(local.read_autoscaling_target.min_capacity, 0)
    actual_max_read_capacity = core::try(local.read_autoscaling_target.max_capacity, 0)
    actual_min_write_capacity = core::try(local.write_autoscaling_target.min_capacity, 0)
    actual_max_write_capacity = core::try(local.write_autoscaling_target.max_capacity, 0)

    actual_read_target_utilization = core::try(local.read_autoscaling_policy.target_tracking_scaling_policy_configuration[0].target_value, 0)
    actual_write_target_utilization = core::try(local.write_autoscaling_policy.target_tracking_scaling_policy_configuration[0].target_value, 0)

    valid_min_read_capacity = input.minProvisionedReadCapacity == 0 || (input.minProvisionedReadCapacity >= 1 && input.minProvisionedReadCapacity <= 40000)
    valid_max_read_capacity = input.maxProvisionedReadCapacity == 0 || (input.maxProvisionedReadCapacity >= 1 && input.maxProvisionedReadCapacity <= 40000)
    valid_target_read_utilization = input.targetReadUtilization == 0 || (input.targetReadUtilization >= 20 && input.targetReadUtilization <= 90)

    valid_min_write_capacity = input.minProvisionedWriteCapacity == 0 || (input.minProvisionedWriteCapacity >= 1 && input.minProvisionedWriteCapacity <= 40000)
    valid_max_write_capacity = input.maxProvisionedWriteCapacity == 0 || (input.maxProvisionedWriteCapacity >= 1 && input.maxProvisionedWriteCapacity <= 40000)
    valid_target_write_utilization = input.targetWriteUtilization == 0 || (input.targetWriteUtilization >= 20 && input.targetWriteUtilization <= 90)

    read_configuration_valid = local.has_read_autoscaling_target && (input.minProvisionedReadCapacity == 0 || local.actual_min_read_capacity == input.minProvisionedReadCapacity) && (input.maxProvisionedReadCapacity == 0 || local.actual_max_read_capacity == input.maxProvisionedReadCapacity) && (input.targetReadUtilization == 0 || (local.has_read_autoscaling_policy && local.actual_read_target_utilization == input.targetReadUtilization))

    write_configuration_valid = local.has_write_autoscaling_target && (input.minProvisionedWriteCapacity == 0 || local.actual_min_write_capacity == input.minProvisionedWriteCapacity) && (input.maxProvisionedWriteCapacity == 0 || local.actual_max_write_capacity == input.maxProvisionedWriteCapacity) && (input.targetWriteUtilization == 0 || (local.has_write_autoscaling_policy && local.actual_write_target_utilization == input.targetWriteUtilization))
  }

  enforce {
    condition = local.valid_min_read_capacity
    error_message = "input.minProvisionedReadCapacity must be between 1 and 40000 when provided. Current value: ${input.minProvisionedReadCapacity}. Use 0 to leave the parameter unset."
  }

  enforce {
    condition = local.valid_max_read_capacity
    error_message = "input.maxProvisionedReadCapacity must be between 1 and 40000 when provided. Current value: ${input.maxProvisionedReadCapacity}. Use 0 to leave the parameter unset."
  }

  enforce {
    condition = local.valid_target_read_utilization
    error_message = "input.targetReadUtilization must be between 20 and 90 when provided. Current value: ${input.targetReadUtilization}. Use 0 to leave the parameter unset."
  }

  enforce {
    condition = local.valid_min_write_capacity
    error_message = "input.minProvisionedWriteCapacity must be between 1 and 40000 when provided. Current value: ${input.minProvisionedWriteCapacity}. Use 0 to leave the parameter unset."
  }

  enforce {
    condition = local.valid_max_write_capacity
    error_message = "input.maxProvisionedWriteCapacity must be between 1 and 40000 when provided. Current value: ${input.maxProvisionedWriteCapacity}. Use 0 to leave the parameter unset."
  }

  enforce {
    condition = local.valid_target_write_utilization
    error_message = "input.targetWriteUtilization must be between 20 and 90 when provided. Current value: ${input.targetWriteUtilization}. Use 0 to leave the parameter unset."
  }

  enforce {
    condition = local.read_configuration_valid && local.write_configuration_valid
    error_message = "Provisioned DynamoDB table '${local.table_name}' must have read and write Application Auto Scaling targets configured, and any supplied autoscaling parameters must match the configured targets and target-tracking policies."
  }
}
