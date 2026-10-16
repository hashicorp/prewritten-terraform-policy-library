# Copyright IBM Corp. 2026

# EBS volumes should have a recent recovery point

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "ebs-backup-recovery-point-created-enforcement-level" {
  type    = string
  default = "advisory"
}

input "ebs-backup-recovery-point-created-max_hours_since_backup" {
  type    = number
  default = 24
}

input "ebs-backup-recovery-point-created-resource_tags" {
  type    = string
  default = ""
}

input "ebs-backup-recovery-point-created-resource_id" {
  type    = string
  default = ""
}

input "ebs-backup-recovery-point-created-recovery_point_age_value" {
  type    = number
  default = 1
}

input "ebs-backup-recovery-point-created-recovery_point_age_unit" {
  type    = string
  default = "days"
}

locals {
  ebsrp_all_backup_plans      = core::getresources("aws_backup_plan", {})
  ebsrp_all_backup_selections = core::getresources("aws_backup_selection", {})

  ebsrp_required_hours = (input.ebs-backup-recovery-point-created-recovery_point_age_value != 1 || input.ebs-backup-recovery-point-created-recovery_point_age_unit != "days") ? (
    input.ebs-backup-recovery-point-created-recovery_point_age_unit == "hours"
    ? input.ebs-backup-recovery-point-created-recovery_point_age_value
    : input.ebs-backup-recovery-point-created-recovery_point_age_value * 24
  ) : input.ebs-backup-recovery-point-created-max_hours_since_backup

  ebsrp_plan_rules = [for p in local.ebsrp_all_backup_plans : {
    id   = core::try(p.id, null) == null ? "" : p.id
    arn  = core::try(p.arn, null) == null ? "" : p.arn
    name = core::try(p.name, null) == null ? "" : p.name
    rules = [for r in(core::try(p.rule, null) == null ? [] : p.rule) : {
      kind  = core::startswith(core::try(r.schedule, ""), "rate(") ? "rate" : (core::startswith(core::try(r.schedule, ""), "cron(") ? "cron" : "")
      parts = core::split(" ", core::trimspace(core::split(")", core::try(core::split("(", core::try(r.schedule, ""))[1], ""))[0]))
    }]
  }]

  ebsrp_plan_hours = [for p in local.ebsrp_plan_rules : {
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

  ebsrp_compliant_plan_ids = [for p in local.ebsrp_plan_hours : p.id if core::length([for h in p.hours : h if h <= local.ebsrp_required_hours]) > 0]
}

resource_policy "aws_ebs_volume" "ebs_backup_recovery_point_created" {
  enforcement_level = input.ebs-backup-recovery-point-created-enforcement-level

  filter = (
    (
      input.ebs-backup-recovery-point-created-resource_id == "" ? true : (
        core::try(attrs.id, "") == input.ebs-backup-recovery-point-created-resource_id ||
        core::try(attrs.arn, "") == input.ebs-backup-recovery-point-created-resource_id
      )
    )
    &&
    (
      input.ebs-backup-recovery-point-created-resource_tags == "" ? true :
      core::length([
        for k, v in core::try(core::jsondecode(input.ebs-backup-recovery-point-created-resource_tags), {}) : k
        if core::try((core::try(attrs.tags, null) != null ? attrs.tags : {})[k], "") != v
      ]) == 0
    )
  )

  locals {
    volume_id       = core::try(attrs.id, "")
    volume_arn      = core::try(attrs.arn, "")
    volume_tags_raw = core::try(attrs.tags, null)
    volume_tags     = local.volume_tags_raw != null ? local.volume_tags_raw : {}

    matching_selections = [for sel in local.ebsrp_all_backup_selections : sel if(
      (
        core::contains(core::try(sel.resources, null) != null ? [for r in sel.resources : r] : [], "*")
        ||
        (
          local.volume_arn != "" &&
          core::contains(core::try(sel.resources, null) != null ? [for r in sel.resources : r] : [], local.volume_arn)
        )
        ||
        (
          local.volume_id != "" &&
          core::length([
            for r in(core::try(sel.resources, null) != null ? [for rr in sel.resources : rr] : [])
            : r if core::endswith(r, ":volume/${local.volume_id}")
          ]) > 0
        )
        ||
        core::length([
          for r in(core::try(sel.resources, null) != null ? [for rr in sel.resources : rr] : [])
          : r if(
            core::startswith(core::lower(r), "arn:aws:ec2:") &&
            (core::endswith(core::lower(r), ":volume/*") || core::endswith(core::lower(r), ":volume/vol-*"))
          )
        ]) > 0
        ||
        (
          core::length(core::try(sel.selection_tag, null) != null ? [for t in sel.selection_tag : t] : []) > 0
          &&
          core::length(core::keys(local.volume_tags)) > 0
          &&
          core::length([
            for t in(core::try(sel.selection_tag, null) != null ? [for tt in sel.selection_tag : tt] : [])
            : t if !(
              core::try(t.type, "STRINGEQUALS") == "STRINGEQUALS" &&
              core::try(local.volume_tags[core::try(t.key, "")], "") == core::try(t.value, "")
            )
          ]) == 0
        )
      )
      &&
      (
        core::try(sel.plan_id, "") != ""
        ? core::contains(local.ebsrp_compliant_plan_ids, core::try(sel.plan_id, ""))
        : core::length(local.ebsrp_compliant_plan_ids) > 0
      )
    )]
  }

  enforce {
    condition     = core::length(local.matching_selections) > 0
    error_message = "Amazon EBS volume '${local.volume_id}' is not associated with a compliant AWS Backup plan scheduled within ${local.ebsrp_required_hours} hour(s) (equivalent to ${input.ebs-backup-recovery-point-created-recovery_point_age_value} ${input.ebs-backup-recovery-point-created-recovery_point_age_unit})."
  }
}
