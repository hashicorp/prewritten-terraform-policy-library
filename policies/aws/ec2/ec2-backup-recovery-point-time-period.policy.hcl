# Copyright IBM Corp. 2026

# EC2 instances should have a recent recovery point

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "ec2-backup-recovery-point-time-period-enforcement-level" {
  type    = string
  default = "advisory"
}

input "ec2-backup-recovery-point-time-period-resource_tags" {
  type    = string
  default = ""
}

input "ec2-backup-recovery-point-time-period-resource_id" {
  type    = string
  default = ""
}

input "ec2-backup-recovery-point-time-period-max_recovery_point_age_hours" {
  type    = number
  default = 24
}

input "ec2-backup-recovery-point-time-period-recovery_point_age_value" {
  type    = number
  default = 1
}

input "ec2-backup-recovery-point-time-period-recovery_point_age_unit" {
  type    = string
  default = "days"
}

locals {
  ec2rp_required_hours = (input.ec2-backup-recovery-point-time-period-recovery_point_age_value != 1 || input.ec2-backup-recovery-point-time-period-recovery_point_age_unit != "days") ? (input.ec2-backup-recovery-point-time-period-recovery_point_age_unit == "hours" ? input.ec2-backup-recovery-point-time-period-recovery_point_age_value : input.ec2-backup-recovery-point-time-period-recovery_point_age_value * 24) : input.ec2-backup-recovery-point-time-period-max_recovery_point_age_hours

  ec2rp_all_backup_plans      = core::getresources("aws_backup_plan", {})
  ec2rp_all_backup_selections = core::getresources("aws_backup_selection", {})

  ec2rp_plan_rules = [for p in local.ec2rp_all_backup_plans : {
    id   = core::try(p.id, null) == null ? "" : p.id
    arn  = core::try(p.arn, null) == null ? "" : p.arn
    name = core::try(p.name, null) == null ? "" : p.name
    rules = [for r in(core::try(p.rule, null) == null ? [] : p.rule) : {
      kind  = core::startswith(core::try(r.schedule, ""), "rate(") ? "rate" : (core::startswith(core::try(r.schedule, ""), "cron(") ? "cron" : "")
      parts = core::split(" ", core::trimspace(core::split(")", core::try(core::split("(", core::try(r.schedule, ""))[1], ""))[0]))
    }]
  }]

  ec2rp_plan_hours = [for p in local.ec2rp_plan_rules : {
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

  ec2rp_compliant_plans     = [for p in local.ec2rp_plan_hours : p if core::length([for h in p.hours : h if h <= local.ec2rp_required_hours]) > 0]
  ec2rp_compliant_plan_ids  = [for p in local.ec2rp_compliant_plans : p.id]
  ec2rp_compliant_plan_arns = [for p in local.ec2rp_compliant_plans : p.arn]
}

resource_policy "aws_instance" "backup_recovery_point_time_period" {
  locals {
    instance_arn      = core::try(attrs.arn, "")
    instance_id       = core::try(attrs.id, "")
    instance_tags_raw = core::try(attrs.tags, null)
    instance_tags     = local.instance_tags_raw != null ? local.instance_tags_raw : {}

    resource_id_in_scope   = input.ec2-backup-recovery-point-time-period-resource_id == "" ? true : (local.instance_id == input.ec2-backup-recovery-point-time-period-resource_id || local.instance_arn == input.ec2-backup-recovery-point-time-period-resource_id)
    resource_tags_filter   = input.ec2-backup-recovery-point-time-period-resource_tags == "" ? {} : core::try(core::jsondecode(input.ec2-backup-recovery-point-time-period-resource_tags), {})
    resource_tags_in_scope = input.ec2-backup-recovery-point-time-period-resource_tags == "" ? true : core::length([for k, v in local.resource_tags_filter : k if core::try(local.instance_tags[k], "") == v]) == core::length(local.resource_tags_filter)
    in_scope               = local.resource_id_in_scope && local.resource_tags_in_scope

    matching_compliant_selections = [for sel in local.ec2rp_all_backup_selections : sel if core::length([for ref in(core::try(sel.not_resources, null) == null ? [] : sel.not_resources) : ref if ref == "*" || (local.instance_arn != "" && ref == local.instance_arn) || (local.instance_id != "" && core::endswith(ref, ":instance/${local.instance_id}"))]) == 0 && (core::length((core::try(sel.resources, null) == null ? [] : sel.resources)) > 0 || core::length((core::try(sel.selection_tag, null) == null ? [] : sel.selection_tag)) > 0 || core::length((core::try(sel.condition, null) == null ? [] : sel.condition)) > 0) && (core::length((core::try(sel.resources, null) == null ? [] : sel.resources)) == 0 || core::length([for ref in(core::try(sel.resources, null) == null ? [] : sel.resources) : ref if ref == "*" || (local.instance_arn != "" && ref == local.instance_arn) || (local.instance_id != "" && core::endswith(ref, ":instance/${local.instance_id}"))]) > 0) && (core::length((core::try(sel.selection_tag, null) == null ? [] : sel.selection_tag)) == 0 || core::length([for t in(core::try(sel.selection_tag, null) == null ? [] : sel.selection_tag) : t if core::try(t.type, "") == "STRINGEQUALS" && core::try(local.instance_tags[core::try(t.key, "")], "") == core::try(t.value, "")]) == core::length((core::try(sel.selection_tag, null) == null ? [] : sel.selection_tag))) && (core::length((core::try(sel.condition, null) == null ? [] : sel.condition)) == 0 || (core::length(core::try((core::try(sel.condition, null) == null ? [] : sel.condition)[0].string_equals, [])) == core::length([for e in core::try((core::try(sel.condition, null) == null ? [] : sel.condition)[0].string_equals, []) : e if core::try(local.instance_tags[core::startswith(core::try(e.key, ""), "aws:ResourceTag/") ? core::try(core::split("aws:ResourceTag/", core::try(e.key, "")), [""])[1] : core::try(e.key, "")], "") == core::try(e.value, "")]) && core::length(core::try((core::try(sel.condition, null) == null ? [] : sel.condition)[0].string_not_equals, [])) == core::length([for e in core::try((core::try(sel.condition, null) == null ? [] : sel.condition)[0].string_not_equals, []) : e if core::try(local.instance_tags[core::startswith(core::try(e.key, ""), "aws:ResourceTag/") ? core::try(core::split("aws:ResourceTag/", core::try(e.key, "")), [""])[1] : core::try(e.key, "")], "") != core::try(e.value, "")]))) && (core::contains(local.ec2rp_compliant_plan_ids, core::try(sel.plan_id, "")) || core::contains(local.ec2rp_compliant_plan_arns, core::try(sel.plan_id, "")))]

    has_compliant_backup = core::length(local.matching_compliant_selections) > 0
  }

  filter = local.in_scope

  enforcement_level = input.ec2-backup-recovery-point-time-period-enforcement-level

  enforce {
    condition     = local.has_compliant_backup
    error_message = "Amazon EC2 instance '${local.instance_id}' must be associated with a compliant AWS Backup plan (via an aws_backup_selection) that creates recovery points at least every ${local.ec2rp_required_hours} hour(s)."
  }
}
