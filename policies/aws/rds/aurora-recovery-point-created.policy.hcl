# Copyright IBM Corp. 2026

# Aurora DB clusters should have a recent recovery point

# LIMITATION: The original Sentinel policy matches an `aws_backup_selection` to an
# `aws_rds_cluster` using the cluster's Terraform resource `address` and `name`
# (`cluster_res.address`, `cluster_res.name`) in addition to `cluster_identifier` and
# tag-based matching. `meta.address` is undefined inside `resource_policy` in tfpolicy,
# so address/name based reference matching cannot be reproduced. This policy matches a
# selection to a cluster via: (a) a `"*"` wildcard entry in `resources`, (b) the
# cluster's `arn` appearing literally in `resources`, (c) the cluster's
# `cluster_identifier` appearing as a substring of any `resources` entry (covers ARN
# suffix patterns such as ":cluster:<id>"), or (d) `selection_tag` matching the
# cluster's `tags`. Clusters referenced only by resource address/name (and not by
# identifier, ARN, or tags) will not be recognized as covered by a backup selection.
#
# LIMITATION: The original Sentinel policy reads `aws_backup_selection.plan_id` from
# `tfconfig/v2`, which exposes whether the value is a literal constant or a reference
# to another resource (`references`/`constant_value`). tfpolicy's `attrs.*` only
# exposes the resolved/planned value, with no reference-vs-literal distinction. This
# policy matches `plan_id` against the backup plan's planned `id` or `name` attribute
# directly; when `plan_id` is empty it falls back to treating any compliant backup
# plan in the plan as a match, matching the Sentinel fallback behavior.

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

# Minimum number of days of automated backup retention required (legacy parameter,
# kept as a lower bound alongside recovery_point_age_value/recovery_point_age_unit).
input "aurora-recovery-point-created-max_days_since_backup" {
  type    = number
  default = 1
}

# Numerical value for the maximum allowed age of a recovery point.
input "aurora-recovery-point-created-recovery_point_age_value" {
  type    = number
  default = 1
}

# Unit of time for recovery_point_age_value. Accepted values: "hours", "days".
input "aurora-recovery-point-created-recovery_point_age_unit" {
  type    = string
  default = "days"
}

# Optional: only evaluate the Aurora cluster whose cluster_identifier equals this value.
input "aurora-recovery-point-created-resource_id" {
  type    = string
  default = ""
}

# Optional: only evaluate Aurora clusters whose tags match this JSON object, e.g. {"env":"prod"}.
input "aurora-recovery-point-created-resource_tags" {
  type    = string
  default = ""
}

locals {
  # aws_backup_selection is a reverse-reference to aws_rds_cluster: its `resources`
  # attribute may hold the cluster's ARN/identifier, and its `plan_id` attribute links
  # it to aws_backup_plan. Both aws_backup_plan and aws_backup_selection are therefore
  # cached, unscoped, at the top level and matched against the current cluster's
  # attrs.* inside resource_policy (see verified-syntax.md "Exception - reverse-reference
  # pattern").
  aurrp_all_backup_plans      = core::getresources("aws_backup_plan", {})
  aurrp_all_backup_selections = core::getresources("aws_backup_selection", {})

  # Backup plan schedules converted to an interval in hours. Shared parsing rules:
  # - rate(N minute(s)) -> 1, rate(N hour(s)) -> N, rate(N day(s)) -> N * 24.
  # - cron(min hour day-of-month month day-of-week year) is daily or more frequent only when
  #   day-of-month and day-of-week are both "*" or "?" and month is "*". Then an hour field
  #   of "*" is hourly, "*/N" or "M/N" is every N hours, and anything else is daily (24).
  # - Every other schedule (weekly, monthly, unparseable) counts as 720 hours (30 days).
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
  # Only Aurora engines are in scope (aurora-mysql, aurora-postgresql).
  filter = core::startswith(core::try(attrs.engine, ""), "aurora")

  locals {
    # ---------------------------------------------------------------------------
    # resourceId / resourceTags scoping (matches the Sentinel policy's optional
    # resourceId and resourceTags params). When set, clusters that do not match
    # are entirely excluded from evaluation.
    # ---------------------------------------------------------------------------
    cluster_identifier = core::try(attrs.cluster_identifier, "")
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

    # ---------------------------------------------------------------------------
    # Required coverage window, derived from recovery_point_age_value/unit.
    # ---------------------------------------------------------------------------
    required_hours = input.aurora-recovery-point-created-recovery_point_age_unit == "hours" ? input.aurora-recovery-point-created-recovery_point_age_value : input.aurora-recovery-point-created-recovery_point_age_value * 24

    # ---------------------------------------------------------------------------
    # Path 1: automated backups enabled directly on the cluster.
    # backup_retention (days) is compliant when it satisfies BOTH the legacy
    # max_days_since_backup floor AND the recovery_point_age_value/unit window
    # (compared in hours to avoid integer ceiling-division: backup_retention*24
    # covers required_hours exactly when backup_retention >= ceil(required_hours/24)).
    # ---------------------------------------------------------------------------
    backup_retention    = core::try(attrs.backup_retention_period, 0)
    has_backup_enabled  = local.backup_retention >= input.aurora-recovery-point-created-max_days_since_backup && (local.backup_retention * 24) >= local.required_hours

    # ---------------------------------------------------------------------------
    # Path 2: a compliant AWS Backup plan reached via an aws_backup_selection
    # that references this cluster (see LIMITATION comments at top of file).
    # ---------------------------------------------------------------------------
    cluster_arn = core::try(attrs.arn, "")

    matching_selections = [for s in local.aurrp_all_backup_selections : s if
      core::contains((core::try(s.resources, null) == null ? [] : s.resources), "*") ||
      (local.cluster_arn != "" && core::contains((core::try(s.resources, null) == null ? [] : s.resources), local.cluster_arn)) ||
      (local.cluster_identifier != "" && core::length([for r in (core::try(s.resources, null) == null ? [] : s.resources) : r if core::contains_substring(r, local.cluster_identifier)]) > 0) ||
      (
        core::length((core::try(s.selection_tag, null) == null ? [] : s.selection_tag)) > 0 &&
        core::length([for st in (core::try(s.selection_tag, null) == null ? [] : s.selection_tag) : st if
          core::try(st.type, "STRINGEQUALS") == "STRINGEQUALS" &&
          core::try(local.cluster_tags[core::try(st.key, "")], "") == core::try(st.value, "")
        ]) == core::length((core::try(s.selection_tag, null) == null ? [] : s.selection_tag))
      )
    ]

    # A backup plan is compliant when at least one rule runs at least every required_hours
    # (see the shared schedule parsing rules in the top-level locals).
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

  # NOTE: This policy evaluates aws_backup_plan/aws_backup_selection via
  # core::getresources(). When the Aurora cluster, its backup selection, and its
  # backup plan are all newly created in the same plan, computed attributes
  # (e.g. the cluster's arn or the plan's id) may be unknown at plan time; the
  # cross-resource match is most reliable on updates and existing infrastructure.
  enforcement_level = input.aurora-recovery-point-created-enforcement-level
  enforce {
    condition     = !local.in_scope || local.is_compliant
    error_message = "Aurora DB cluster '${local.cluster_identifier}' must have either automated backups enabled with a backup_retention_period of at least ${input.aurora-recovery-point-created-max_days_since_backup} day(s) (covering ${input.aurora-recovery-point-created-recovery_point_age_value} ${input.aurora-recovery-point-created-recovery_point_age_unit}) or be associated with a compliant AWS Backup plan via an aws_backup_selection. Current backup_retention_period: ${local.backup_retention}."
  }
}
