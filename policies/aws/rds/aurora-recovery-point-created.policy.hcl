# Copyright IBM Corp. 2026

# Aurora DB clusters should have a recent recovery point

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "aurora-recovery-point-created-enforcement-level" {
  type    = string
  default = "advisory"
}

input "aurora-recovery-point-created-max_days_since_backup" {
  type    = number
  default = 1
}

input "aurora-recovery-point-created-recovery_point_age_value" {
  type    = number
  default = 1
}

input "aurora-recovery-point-created-recovery_point_age_unit" {
  type    = string
  default = "days"
}

input "aurora-recovery-point-created-resource_id" {
  type    = string
  default = ""
}

input "aurora-recovery-point-created-resource_tags" {
  type    = string
  default = ""
}

locals {
  aurrp_all_backup_plans      = core::getresources("aws_backup_plan", {})
  aurrp_all_backup_selections = core::getresources("aws_backup_selection", {})

  aurrp_plan_rules = [for p in local.aurrp_all_backup_plans : {
    id   = core::try(p.id, null) == null ? "" : p.id
    arn  = core::try(p.arn, null) == null ? "" : p.arn
    name = core::try(p.name, null) == null ? "" : p.name
    rules = [for r in(core::try(p.rule, null) == null ? [] : p.rule) : {
      kind  = core::startswith(core::try(r.schedule, ""), "rate(") ? "rate" : (core::startswith(core::try(r.schedule, ""), "cron(") ? "cron" : "")
      parts = core::split(" ", core::trimspace(core::split(")", core::try(core::split("(", core::try(r.schedule, ""))[1], ""))[0]))
    }]
  }]

  aurrp_plan_hours = [for p in local.aurrp_plan_rules : {
    id   = p.id
    arn  = p.arn
    name = p.name
    hours = [for r in p.rules :
      r.kind == "rate" ? (
        core::length(r.parts) != 2 ? 720 :
        core::startswith(r.parts[1], "minute") ? 1 :
        core::startswith(r.parts[1], "hour") ? core::try(core::parseint(r.parts[0], 10), 720) :
        core::startswith(r.parts[1], "day") ? core::try(core::parseint(r.parts[0], 10), 30) * 24 :
        720
        ) : r.kind == "cron" ? (
        core::length(r.parts) != 6 ? 720 :
        !(core::contains(["*", "?"], r.parts[2]) && core::contains(["*", "?"], r.parts[4]) && r.parts[3] == "*") ? 720 :
        r.parts[1] == "*" ? 1 :
        core::length(core::split("/", r.parts[1])) == 2 ? core::try(core::parseint(core::split("/", r.parts[1])[1], 10), 24) :
        24
      ) : 720
    ]
  }]
}

resource_policy "aws_rds_cluster" "aurora_recovery_point_created" {
  filter = core::startswith(core::try(attrs.engine, ""), "aurora")

  locals {
    cluster_identifier  = core::try(attrs.cluster_identifier, "")
    matches_resource_id = input.aurora-recovery-point-created-resource_id == "" ? true : local.cluster_identifier == input.aurora-recovery-point-created-resource_id

    cluster_tags_raw = core::try(attrs.tags, null)
    cluster_tags     = local.cluster_tags_raw != null ? local.cluster_tags_raw : {}

    filter_tags_raw = input.aurora-recovery-point-created-resource_tags == "" ? {} : core::try(core::jsondecode(input.aurora-recovery-point-created-resource_tags), {})
    filter_tag_keys = core::keys(local.filter_tags_raw)
    unmatched_filter_tags = [for k in local.filter_tag_keys : k if
      core::try(local.cluster_tags[k], "") != core::try(local.filter_tags_raw[k], "")
    ]
    matches_resource_tags = input.aurora-recovery-point-created-resource_tags == "" ? true : core::length(local.unmatched_filter_tags) == 0

    in_scope = local.matches_resource_id && local.matches_resource_tags

    required_hours = input.aurora-recovery-point-created-recovery_point_age_unit == "hours" ? input.aurora-recovery-point-created-recovery_point_age_value : input.aurora-recovery-point-created-recovery_point_age_value * 24

    backup_retention   = core::try(attrs.backup_retention_period, 0)
    has_backup_enabled = local.backup_retention >= input.aurora-recovery-point-created-max_days_since_backup && (local.backup_retention * 24) >= local.required_hours

    cluster_arn = core::try(attrs.arn, "")

    matching_selections = [for s in local.aurrp_all_backup_selections : s if
      core::contains((core::try(s.resources, null) == null ? [] : s.resources), "*") ||
      (local.cluster_arn != "" && core::contains((core::try(s.resources, null) == null ? [] : s.resources), local.cluster_arn)) ||
      (local.cluster_identifier != "" && core::length([for r in(core::try(s.resources, null) == null ? [] : s.resources) : r if core::contains_substring(r, local.cluster_identifier)]) > 0) ||
      (
        core::length((core::try(s.selection_tag, null) == null ? [] : s.selection_tag)) > 0 &&
        core::length([for st in(core::try(s.selection_tag, null) == null ? [] : s.selection_tag) : st if
          core::try(st.type, "STRINGEQUALS") == "STRINGEQUALS" &&
          core::try(local.cluster_tags[core::try(st.key, "")], "") == core::try(st.value, "")
        ]) == core::length((core::try(s.selection_tag, null) == null ? [] : s.selection_tag))
      )
    ]

    compliant_plans = [for p in local.aurrp_plan_hours : p if core::length([for h in p.hours : h if h <= local.required_hours]) > 0]

    compliant_plan_ids   = [for p in local.compliant_plans : p.id]
    compliant_plan_names = [for p in local.compliant_plans : p.name]
    any_plan_compliant   = core::length(local.compliant_plans) > 0

    has_compliant_backup_plan = core::length([for s in local.matching_selections : s if
      core::try(s.plan_id, "") == "" ?
      local.any_plan_compliant
      :
      core::contains(local.compliant_plan_ids, core::try(s.plan_id, "")) || core::contains(local.compliant_plan_names, core::try(s.plan_id, ""))
    ]) > 0

    is_compliant = local.has_backup_enabled || local.has_compliant_backup_plan
  }

  enforcement_level = input.aurora-recovery-point-created-enforcement-level
  enforce {
    condition     = !local.in_scope || local.is_compliant
    error_message = "Aurora DB cluster '${local.cluster_identifier}' must have either automated backups enabled with a backup_retention_period of at least ${input.aurora-recovery-point-created-max_days_since_backup} day(s) (covering ${input.aurora-recovery-point-created-recovery_point_age_value} ${input.aurora-recovery-point-created-recovery_point_age_unit}) or be associated with a compliant AWS Backup plan via an aws_backup_selection. Current backup_retention_period: ${local.backup_retention}."
  }
}
