# Copyright IBM Corp. 2026

# RDS databases should have a recent recovery point

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "rds-recovery-point-created-within-time-period-enforcement-level" {
  type    = string
  default = "advisory"
}

input "rds-recovery-point-created-within-time-period-recovery_point_age_value" {
  type    = number
  default = 1
}

input "rds-recovery-point-created-within-time-period-recovery_point_age_unit" {
  type    = string
  default = "days"
}

input "rds-recovery-point-created-within-time-period-resource_id" {
  type    = string
  default = ""
}

input "rds-recovery-point-created-within-time-period-resource_tags" {
  type    = map(string)
  default = {}
}

locals {
  rdsrp_all_backup_plans      = core::getresources("aws_backup_plan", {})
  rdsrp_all_iam_roles         = core::getresources("aws_iam_role", {})
  rdsrp_all_backup_selections = core::getresources("aws_backup_selection", {})

  rdsrp_valid_plan_ids  = [for p in local.rdsrp_all_backup_plans : core::try(p.id, "")]
  rdsrp_valid_role_arns = [for r in local.rdsrp_all_iam_roles : core::try(r.arn, "")]

  rdsrp_valid_selections = [
    for s in local.rdsrp_all_backup_selections : s
    if core::contains(local.rdsrp_valid_plan_ids, core::try(s.plan_id, "")) &&
    core::contains(local.rdsrp_valid_role_arns, core::try(s.iam_role_arn, ""))
  ]
}

resource_policy "aws_db_instance" "rds_recovery_point_created_within_time_period" {
  filter = (
    input.rds-recovery-point-created-within-time-period-resource_id == "" || core::try(attrs.identifier, "") == input.rds-recovery-point-created-within-time-period-resource_id
    ) && (
    core::length(input.rds-recovery-point-created-within-time-period-resource_tags) == 0 ||
    core::length([
      for k, v in input.rds-recovery-point-created-within-time-period-resource_tags : k
      if core::contains(
        [for tk, tv in core::try(attrs.tags, {}) : "${tk}=${tv}"],
        "${k}=${v}"
      )
    ]) == core::length(input.rds-recovery-point-created-within-time-period-resource_tags)
  )

  locals {
    rds_identifier = core::try(attrs.identifier, "")
    rds_arn        = core::try(attrs.arn, "")
    rds_tags_raw   = core::try(attrs.tags, null)
    rds_tags       = local.rds_tags_raw != null ? local.rds_tags_raw : {}

    arn_matched = core::length([
      for s in local.rdsrp_valid_selections : s
      if core::length([
        for r in(core::try(s.resources, null) == null ? [] : s.resources) : r
        if r == local.rds_arn || core::endswith(r, ":*") || core::endswith(r, ":${local.rds_identifier}")
      ]) > 0
    ]) > 0

    tag_matched = core::length([
      for s in local.rdsrp_valid_selections : s
      if core::length((core::try(s.selection_tag, null) == null ? [] : s.selection_tag)) > 0 &&
      core::length([
        for t in(core::try(s.selection_tag, null) == null ? [] : s.selection_tag) : t
        if core::try(local.rds_tags[core::try(t.key, "")], "") == core::try(t.value, "")
      ]) == core::length((core::try(s.selection_tag, null) == null ? [] : s.selection_tag))
    ]) > 0

    in_backup_selection = local.arn_matched || local.tag_matched

    backup_retention  = core::try(attrs.backup_retention_period, 0)
    has_backup_config = local.backup_retention > 0
  }

  enforcement_level = input.rds-recovery-point-created-within-time-period-enforcement-level

  enforce {
    condition     = local.in_backup_selection
    error_message = "RDS instance '${local.rds_identifier}' is not included in any AWS Backup selection. Recovery points must be created within ${input.rds-recovery-point-created-within-time-period-recovery_point_age_value} ${input.rds-recovery-point-created-within-time-period-recovery_point_age_unit}. Configure AWS Backup with proper dependencies (aws_backup_plan, aws_iam_role) to ensure timely recovery points."
  }

  enforce {
    condition     = local.has_backup_config
    error_message = "RDS instance '${local.rds_identifier}' does not have adequate backup configuration to ensure recovery points are created within ${input.rds-recovery-point-created-within-time-period-recovery_point_age_value} ${input.rds-recovery-point-created-within-time-period-recovery_point_age_unit}. Set backup_retention_period to a value greater than 0 to enable automated backups."
  }
}

resource_policy "aws_rds_cluster" "rds_recovery_point_created_within_time_period" {
  filter = (
    input.rds-recovery-point-created-within-time-period-resource_id == "" || core::try(attrs.cluster_identifier, "") == input.rds-recovery-point-created-within-time-period-resource_id
    ) && (
    core::length(input.rds-recovery-point-created-within-time-period-resource_tags) == 0 ||
    core::length([
      for k, v in input.rds-recovery-point-created-within-time-period-resource_tags : k
      if core::contains(
        [for tk, tv in core::try(attrs.tags, {}) : "${tk}=${tv}"],
        "${k}=${v}"
      )
    ]) == core::length(input.rds-recovery-point-created-within-time-period-resource_tags)
  )

  locals {
    rds_identifier = core::try(attrs.cluster_identifier, "")
    rds_arn        = core::try(attrs.arn, "")
    rds_tags_raw   = core::try(attrs.tags, null)
    rds_tags       = local.rds_tags_raw != null ? local.rds_tags_raw : {}

    arn_matched = core::length([
      for s in local.rdsrp_valid_selections : s
      if core::length([
        for r in(core::try(s.resources, null) == null ? [] : s.resources) : r
        if r == local.rds_arn || core::endswith(r, ":*") || core::endswith(r, ":${local.rds_identifier}")
      ]) > 0
    ]) > 0

    tag_matched = core::length([
      for s in local.rdsrp_valid_selections : s
      if core::length((core::try(s.selection_tag, null) == null ? [] : s.selection_tag)) > 0 &&
      core::length([
        for t in(core::try(s.selection_tag, null) == null ? [] : s.selection_tag) : t
        if core::try(local.rds_tags[core::try(t.key, "")], "") == core::try(t.value, "")
      ]) == core::length((core::try(s.selection_tag, null) == null ? [] : s.selection_tag))
    ]) > 0

    in_backup_selection = local.arn_matched || local.tag_matched

    backup_retention  = core::try(attrs.backup_retention_period, 0)
    has_backup_config = local.backup_retention > 0
  }

  enforcement_level = input.rds-recovery-point-created-within-time-period-enforcement-level

  enforce {
    condition     = local.in_backup_selection
    error_message = "RDS cluster '${local.rds_identifier}' is not included in any AWS Backup selection. Recovery points must be created within ${input.rds-recovery-point-created-within-time-period-recovery_point_age_value} ${input.rds-recovery-point-created-within-time-period-recovery_point_age_unit}. Configure AWS Backup with proper dependencies (aws_backup_plan, aws_iam_role) to ensure timely recovery points."
  }

  enforce {
    condition     = local.has_backup_config
    error_message = "RDS cluster '${local.rds_identifier}' does not have adequate backup configuration to ensure recovery points are created within ${input.rds-recovery-point-created-within-time-period-recovery_point_age_value} ${input.rds-recovery-point-created-within-time-period-recovery_point_age_unit}. Set backup_retention_period to a value greater than 0 to enable automated backups."
  }
}
