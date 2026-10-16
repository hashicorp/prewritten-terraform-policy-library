# Copyright IBM Corp. 2026

# EBS volumes should have a recent recovery point

# LIMITATION: The original Sentinel policy can also match a backup
# selection's `resources` entries against the Terraform resource address
# and resource label (e.g. "aws_ebs_volume.example") via regex, and has a
# narrow fallback that matches a single unresolved volume in the plan when
# neither its `id` nor `arn` is known yet. tfpolicy's `resource_policy` does
# not expose the resource address or configuration label (`meta.address` is
# undefined for resource_policy), so these two matching routes cannot be
# converted. All other matching routes from the Sentinel source (exact ARN
# match, wildcard "*", ARN-suffix match on volume id, generic
# "arn:aws:ec2:*:volume/*" / "arn:aws:ec2:*:volume/vol-*" wildcard patterns,
# and tag-based selection matching) are fully implemented below. Likewise,
# `selection_has_compliant_plan()` in Sentinel can match `plan_id` against a
# backup plan's Terraform resource address/label or its position in a
# `references` list; tfpolicy only has access to the plan's resolved `id`
# attribute, so matching is implemented against `plan.id` (the common,
# real-world case where `plan_id = aws_backup_plan.<label>.id`).
#
# NOTE: This policy performs a cross-resource lookup (aws_backup_selection /
# aws_backup_plan) that resolves correctly on `terraform plan` for existing
# infrastructure. For a first-time-create plan where the backup plan/
# selection and the EBS volume are all being created in the same plan, some
# referenced attributes (e.g. `plan_id`, `resources` entries derived from
# `.arn`) may be unknown at plan time; the policy resolves correctly once
# those values are known (i.e., on `terraform apply` / subsequent plans).

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

# input blocks mirror the Sentinel policy's `param` declarations so that
# policy sets can tune the thresholds without editing this file.
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
  # Cache AWS Backup plans/selections once. These are independent resource
  # types queried with an empty filter at the top level because the match
  # against a given EBS volume cannot be expressed as a simple filter_map
  # equality (it requires wildcard/suffix matching over the `resources` list
  # and tag comparisons) -- the volume-specific matching happens inside the
  # resource_policy block below (mirrors the aws_s3_bucket_versioning
  # top-level-cache pattern).
  ebsrp_all_backup_plans      = core::getresources("aws_backup_plan", {})
  ebsrp_all_backup_selections = core::getresources("aws_backup_selection", {})

  # get_required_hours(): resolve the maximum allowed age (in hours) since
  # the last AWS Backup recovery point for a covered EBS volume.
  ebsrp_required_hours = (input.ebs-backup-recovery-point-created-recovery_point_age_value != 1 || input.ebs-backup-recovery-point-created-recovery_point_age_unit != "days") ? (
    input.ebs-backup-recovery-point-created-recovery_point_age_unit == "hours"
    ? input.ebs-backup-recovery-point-created-recovery_point_age_value
    : input.ebs-backup-recovery-point-created-recovery_point_age_value * 24
  ) : input.ebs-backup-recovery-point-created-max_hours_since_backup

  # Backup plan schedules converted to an interval in hours. Shared parsing rules:
  # - rate(N minute(s)) -> 1, rate(N hour(s)) -> N, rate(N day(s)) -> N * 24.
  # - cron(min hour day-of-month month day-of-week year) is daily or more frequent only when
  #   day-of-month and day-of-week are both "*" or "?" and month is "*". Then an hour field
  #   of "*" is hourly, "*/N" or "M/N" is every N hours, and anything else is daily (24).
  # - Every other schedule (weekly, monthly, unparseable) counts as 720 hours (30 days).
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

  # matches_resource_id() / matches_resource_tags(): only evaluate volumes
  # that satisfy the optional resource_id / resource_tags inputs. Volumes
  # that don't match are skipped entirely (not a violation), mirroring the
  # Sentinel policy's pre-filtering of the checked resource set.
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

    # has_compliant_backup_plan(): the volume is compliant if ANY backup
    # selection both (a) references this volume (selection_references_volume)
    # and (b) is linked to a compliant backup plan (selection_has_compliant_plan).
    matching_selections = [for sel in local.ebsrp_all_backup_selections : sel if(
      (
        # selection_references_volume() -- ARN/wildcard matching routes
        # (the resource-address/name matching route is not convertible --
        # see LIMITATION comment at the top of this file).
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
          # selection_matches_volume_tags() fallback: every STRINGEQUALS
          # selection_tag entry must match an equivalent volume tag, and
          # both the selection and the volume must have at least one tag.
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
        # selection_has_compliant_plan(): match the selection's plan_id
        # against the id of a compliant backup plan; if plan_id is empty,
        # fall back to checking whether ANY backup plan is compliant.
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
