# Copyright IBM Corp. 2026

# EFS file systems should have a recent recovery point

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "efs-recovery-point-compliance-enforcement-level" {
  type    = string
  default = "advisory"
}

input "efs-recovery-point-compliance-recovery_point_max_age_hours" {
  type    = number
  default = 24
}

input "efs-recovery-point-compliance-resource_tags" {
  type    = string
  default = ""
}

input "efs-recovery-point-compliance-resource_id" {
  type    = string
  default = ""
}

input "efs-recovery-point-compliance-recovery_point_age_value" {
  type    = number
  default = 1
}

input "efs-recovery-point-compliance-recovery_point_age_unit" {
  type    = string
  default = "days"
}

locals {
  efsrp_required_hours = (
    (input.efs-recovery-point-compliance-recovery_point_age_value != 1 || input.efs-recovery-point-compliance-recovery_point_age_unit != "days")
    ? (
      input.efs-recovery-point-compliance-recovery_point_age_unit == "hours"
      ? input.efs-recovery-point-compliance-recovery_point_age_value
      : input.efs-recovery-point-compliance-recovery_point_age_value * 24
    )
    : input.efs-recovery-point-compliance-recovery_point_max_age_hours
  )

  efsrp_all_backup_plans      = core::getresources("aws_backup_plan", {})
  efsrp_all_backup_selections = core::getresources("aws_backup_selection", {})

  efsrp_plan_rules = [for p in local.efsrp_all_backup_plans : {
    id   = core::try(p.id, null) == null ? "" : p.id
    arn  = core::try(p.arn, null) == null ? "" : p.arn
    name = core::try(p.name, null) == null ? "" : p.name
    rules = [for r in(core::try(p.rule, null) == null ? [] : p.rule) : {
      kind  = core::startswith(core::try(r.schedule, ""), "rate(") ? "rate" : (core::startswith(core::try(r.schedule, ""), "cron(") ? "cron" : "")
      parts = core::split(" ", core::trimspace(core::split(")", core::try(core::split("(", core::try(r.schedule, ""))[1], ""))[0]))
    }]
  }]

  efsrp_plan_hours = [for p in local.efsrp_plan_rules : {
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

  efsrp_compliant_plan_ids = [for p in local.efsrp_plan_hours : p.id if core::length([for h in p.hours : h if h <= local.efsrp_required_hours]) > 0]

  efsrp_resource_tags_raw    = core::try(input.efs-recovery-point-compliance-resource_tags, "")
  efsrp_resource_tags_filter = local.efsrp_resource_tags_raw != "" ? core::try(core::jsondecode(local.efsrp_resource_tags_raw), {}) : {}

  efsrp_selections_normalized = [for selres in local.efsrp_all_backup_selections : {
    plan_id        = core::try(selres.plan_id, "")
    resources      = core::try(selres.resources, null) != null ? core::try(selres.resources, null) : []
    not_resources  = core::try(selres.not_resources, null) != null ? core::try(selres.not_resources, null) : []
    selection_tags = core::try(selres.selection_tag, null) != null ? core::try(selres.selection_tag, null) : []
    conditions = [for cb in(core::try(selres.condition, null) != null ? core::try(selres.condition, null) : []) : {
      string_equals     = core::try(cb.string_equals, null) != null ? core::try(cb.string_equals, null) : []
      string_not_equals = core::try(cb.string_not_equals, null) != null ? core::try(cb.string_not_equals, null) : []
      string_like       = core::try(cb.string_like, null) != null ? core::try(cb.string_like, null) : []
      string_not_like   = core::try(cb.string_not_like, null) != null ? core::try(cb.string_not_like, null) : []
    }]
  }]
}

resource_policy "aws_efs_file_system" "efs_recovery_point_compliance" {
  enforcement_level = input.efs-recovery-point-compliance-enforcement-level

  filter = (
    (input.efs-recovery-point-compliance-resource_id == "" ? true : (core::try(attrs.id, "") == input.efs-recovery-point-compliance-resource_id || core::try(attrs.arn, "") == input.efs-recovery-point-compliance-resource_id))
    &&
    (
      local.efsrp_resource_tags_raw == "" ? true :
      core::length([for k, v in local.efsrp_resource_tags_filter : k if core::try(core::try(attrs.tags, {})[k], "") != v]) == 0
    )
  )

  locals {
    efs_arn      = core::try(attrs.arn, "")
    efs_id       = core::try(attrs.id, "")
    efs_tags_raw = core::try(attrs.tags, null)
    efs_tags     = local.efs_tags_raw != null ? local.efs_tags_raw : {}

    selection_coverage = [for sn in local.efsrp_selections_normalized : {
      plan_id = sn.plan_id

      is_covering = (
        core::length([for ref in sn.not_resources : ref if
          core::try(ref, "") == "*" ||
          core::try(ref, "") == local.efs_arn ||
          (local.efs_id != "" && core::endswith(core::try(ref, ""), ":file-system/${local.efs_id}")) ||
          core::try(core::regex("(?i)arn:aws:elasticfilesystem:.*:file-system/\\*", core::try(ref, "")), null) != null ||
          core::try(core::regex("(?i)arn:aws:elasticfilesystem:.*:file-system/fs-\\*", core::try(ref, "")), null) != null
        ]) == 0
        ) && (
        core::length(sn.resources) > 0 ||
        core::length(sn.selection_tags) > 0 ||
        core::length(sn.conditions) > 0
        ) && (
        core::length(sn.resources) == 0 ||
        core::length([for ref in sn.resources : ref if
          core::try(ref, "") == "*" ||
          core::try(ref, "") == local.efs_arn ||
          (local.efs_id != "" && core::endswith(core::try(ref, ""), ":file-system/${local.efs_id}")) ||
          core::try(core::regex("(?i)arn:aws:elasticfilesystem:.*:file-system/\\*", core::try(ref, "")), null) != null ||
          core::try(core::regex("(?i)arn:aws:elasticfilesystem:.*:file-system/fs-\\*", core::try(ref, "")), null) != null
        ]) > 0
        ) && (
        core::length(sn.selection_tags) == 0 ||
        core::length([for st in sn.selection_tags : st if
          core::try(st.type, "") == "STRINGEQUALS" &&
          core::try(core::try(local.efs_tags, {})[core::try(st.key, "")], "") == core::try(st.value, "")
        ]) == core::length(sn.selection_tags)
        ) && (
        core::length(sn.conditions) == 0 ||
        (
          core::try(core::length(local.efs_tags), 0) > 0 &&
          core::length([for cb in sn.conditions : cb if
            core::length([for e in cb.string_equals : e if core::try(core::try(local.efs_tags, {})[core::try(e.key, "")], "") == core::try(e.value, "")]) == core::length(cb.string_equals) &&
            core::length([for e in cb.string_not_equals : e if core::try(core::try(local.efs_tags, {})[core::try(e.key, "")], "") != core::try(e.value, "")]) == core::length(cb.string_not_equals) &&
            core::length([for e in cb.string_like : e if core::try(core::regex(core::try(e.value, ""), core::try(core::try(local.efs_tags, {})[core::try(e.key, "")], "")), null) != null]) == core::length(cb.string_like) &&
            core::length([for e in cb.string_not_like : e if core::try(core::regex(core::try(e.value, ""), core::try(core::try(local.efs_tags, {})[core::try(e.key, "")], "")), null) == null]) == core::length(cb.string_not_like)
          ]) == core::length(sn.conditions)
        )
      )
    }]

    has_compliant_backup = core::length([for sc in local.selection_coverage : sc if sc.is_covering && core::contains(local.efsrp_compliant_plan_ids, sc.plan_id)]) > 0
  }

  enforce {
    condition     = local.has_compliant_backup
    error_message = "Amazon EFS file system '${attrs.id}' is not associated with a compliant AWS Backup plan that can create recovery points within ${local.efsrp_required_hours} hour(s)."
  }
}
