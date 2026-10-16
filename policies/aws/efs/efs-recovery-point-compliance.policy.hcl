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

# ===========================================================================
# Params (converted from the Sentinel policy's `param` blocks)
# ===========================================================================
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

# ===========================================================================
# Top-level locals: compute the required recovery-point age in hours
# (mirrors get_required_hours()) and determine, once, which AWS Backup plan
# IDs are "compliant" (have a rule whose backup schedule frequency is <=
# required_hours), mirroring is_backup_plan_compliant() and
# get_backup_frequency_hours(). These values do not depend on the EFS
# resource currently being evaluated, so they are computed once at the top
# level and reused by every resource_policy evaluation.
# ===========================================================================
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

  # Backup plan schedules converted to an interval in hours. Shared parsing rules:
  # - rate(N minute(s)) -> 1, rate(N hour(s)) -> N, rate(N day(s)) -> N * 24.
  # - cron(min hour day-of-month month day-of-week year) is daily or more frequent only when
  #   day-of-month and day-of-week are both "*" or "?" and month is "*". Then an hour field
  #   of "*" is hourly, "*/N" or "M/N" is every N hours, and anything else is daily (24).
  # - Every other schedule (weekly, monthly, unparseable) counts as 720 hours (30 days).
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

  # resourceTags filter, parsed once (JSON object of tag key/value pairs).
  efsrp_resource_tags_raw    = core::try(input.efs-recovery-point-compliance-resource_tags, "")
  efsrp_resource_tags_filter = local.efsrp_resource_tags_raw != "" ? core::try(core::jsondecode(local.efsrp_resource_tags_raw), {}) : {}

  # Normalize every backup selection's optional nested set-of-objects
  # attributes (including the condition block's string_equals /
  # string_not_equals / string_like / string_not_like sub-blocks). These are
  # nested (non-top-level) attribute accesses, and an unset optional
  # set/list block here evaluates to `null` directly (it does NOT throw), so
  # core::try() alone does not catch it. Each field below is explicitly
  # null-coalesced to its empty-collection default.
  efsrp_selections_normalized = [for selres in local.efsrp_all_backup_selections : {
    plan_id        = core::try(selres.plan_id, "")
    resources      = core::try(selres.resources, null) != null ? core::try(selres.resources, null) : []
    not_resources  = core::try(selres.not_resources, null) != null ? core::try(selres.not_resources, null) : []
    selection_tags = core::try(selres.selection_tag, null) != null ? core::try(selres.selection_tag, null) : []
    conditions = [for cb in (core::try(selres.condition, null) != null ? core::try(selres.condition, null) : []) : {
      string_equals     = core::try(cb.string_equals, null) != null ? core::try(cb.string_equals, null) : []
      string_not_equals = core::try(cb.string_not_equals, null) != null ? core::try(cb.string_not_equals, null) : []
      string_like       = core::try(cb.string_like, null) != null ? core::try(cb.string_like, null) : []
      string_not_like   = core::try(cb.string_not_like, null) != null ? core::try(cb.string_not_like, null) : []
    }]
  }]
}

# NOTE: This policy performs cross-resource lookups (aws_backup_plan,
# aws_backup_selection) relative to the aws_efs_file_system resource being
# evaluated. These companion resources may still be unresolved during plan
# time (e.g. a selection's plan_id referencing a plan not yet applied), but
# the policy evaluates correctly once the configuration is applied.
#
# LIMITATION: The original Sentinel policy's matches_efs_reference() also
# matched a backup selection's `resources` / `not_resources` entries against
# the EFS resource's Terraform config address and resource name (e.g. a
# reference like "module.x.aws_efs_file_system.foo"), and special-cased a
# generic EFS wildcard ARN reference when the file system's own ARN/ID was
# still unknown at Sentinel's plan-time evaluation and only one EFS resource
# existed in the whole configuration. Terraform Policy's resource_policy
# does not expose `meta.address` or the resource's config name, and
# evaluates `attrs` once they are resolved (so the "unknown ARN/ID" special
# case does not apply here). This policy therefore matches `resources` /
# `not_resources` entries by resolved ARN/ID value and by the same
# "matches all EFS file systems" ARN wildcard patterns used by the Sentinel
# policy; it does not match by Terraform config address or resource name.
#
# LIMITATION: selection_has_compliant_plan() in the Sentinel source also
# supported resolving `plan_id` via Terraform config-time references
# (`plan_refs`) and via a plan's display `name` attribute, falling back to
# "any compliant plan in the configuration" only when a selection had
# neither a config-time reference nor a non-empty `plan_id` value (an
# unreachable case here, since `plan_id` is a required argument of
# aws_backup_selection). This policy matches a selection's `plan_id` against
# the resolved `id` of each aws_backup_plan resource, which is the value
# `plan_id` holds once the configuration is applied.
resource_policy "aws_efs_file_system" "efs_recovery_point_compliance" {
  enforcement_level = input.efs-recovery-point-compliance-enforcement-level

  # Mirrors matches_resource_id() + matches_resource_tags(): only evaluate
  # EFS file systems that match the optional resourceId / resourceTags
  # filters (empty filters match everything).
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

    # selection_covers_efs() + selection_has_compliant_plan(), combined into
    # a single per-selection evaluation (see LIMITATION notes above).
    # Uses local.efsrp_selections_normalized (top-level) so every nested optional
    # block is already null-coalesced.
    selection_coverage = [for sn in local.efsrp_selections_normalized : {
      plan_id = sn.plan_id

      is_covering = (
        # selection_excludes_efs(): not excluded via not_resources.
        core::length([for ref in sn.not_resources : ref if
          core::try(ref, "") == "*" ||
          core::try(ref, "") == local.efs_arn ||
          (local.efs_id != "" && core::endswith(core::try(ref, ""), ":file-system/${local.efs_id}")) ||
          core::try(core::regex("(?i)arn:aws:elasticfilesystem:.*:file-system/\\*", core::try(ref, "")), null) != null ||
          core::try(core::regex("(?i)arn:aws:elasticfilesystem:.*:file-system/fs-\\*", core::try(ref, "")), null) != null
        ]) == 0
      ) && (
        # selection must specify at least one of resources / selection_tag / condition.
        core::length(sn.resources) > 0 ||
        core::length(sn.selection_tags) > 0 ||
        core::length(sn.conditions) > 0
      ) && (
        # resource_match: vacuously true if no `resources` entries; else at least one must match.
        core::length(sn.resources) == 0 ||
        core::length([for ref in sn.resources : ref if
          core::try(ref, "") == "*" ||
          core::try(ref, "") == local.efs_arn ||
          (local.efs_id != "" && core::endswith(core::try(ref, ""), ":file-system/${local.efs_id}")) ||
          core::try(core::regex("(?i)arn:aws:elasticfilesystem:.*:file-system/\\*", core::try(ref, "")), null) != null ||
          core::try(core::regex("(?i)arn:aws:elasticfilesystem:.*:file-system/fs-\\*", core::try(ref, "")), null) != null
        ]) > 0
      ) && (
        # tag_match (selection_matches_efs_tags): vacuously true if no selection_tag
        # entries; else every entry must be type STRINGEQUALS and match exactly.
        core::length(sn.selection_tags) == 0 ||
        core::length([for st in sn.selection_tags : st if
          core::try(st.type, "") == "STRINGEQUALS" &&
          core::try(core::try(local.efs_tags, {})[core::try(st.key, "")], "") == core::try(st.value, "")
        ]) == core::length(sn.selection_tags)
      ) && (
        # condition_match (selection_conditions_match): vacuously true if no condition
        # blocks; else EFS must have tags, and every string_equals/string_not_equals/
        # string_like/string_not_like entry (across every condition block) must match.
        # (The Sentinel generic test/variable/values branch is dead code for this
        # resource type: aws_backup_selection's condition block only exposes the
        # string_equals/string_not_equals/string_like/string_not_like sub-blocks.)
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

    # has_compliant_backup_plan(): at least one covering selection must link
    # (via plan_id) to a plan ID in compliant_plan_ids.
    has_compliant_backup = core::length([for sc in local.selection_coverage : sc if sc.is_covering && core::contains(local.efsrp_compliant_plan_ids, sc.plan_id)]) > 0
  }

  enforce {
    condition     = local.has_compliant_backup
    error_message = "Amazon EFS file system '${attrs.id}' is not associated with a compliant AWS Backup plan that can create recovery points within ${local.efsrp_required_hours} hour(s)."
  }
}
