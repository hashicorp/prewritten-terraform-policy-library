# Copyright IBM Corp. 2026

# DynamoDB tables should have a recent recovery point

# LIMITATION: This policy approximates the original Sentinel policy's reference-metadata
# based matching with resolved-value matching, because tfpolicy does not expose Terraform
# resource addresses, resource labels, or attribute "references"/"constant_value" metadata
# (core::getresources() results only expose resolved provider attributes). Specifically:
#   - aws_backup_selection.plan_id is matched against the resolved .id, .arn, and .name of
#     aws_backup_plan resources in the plan (not against Terraform resource address/label
#     matching as the Sentinel source does).
#   - aws_backup_selection.resources entries are matched against the DynamoDB table's
#     resolved name/arn (wildcard "*", exact arn, name, ARN-suffix "table/<name>", and the
#     generic "arn:aws:dynamodb:*:*:table/*" wildcard pattern) instead of Terraform resource
#     address/label matching.
#   - AWS Backup cron() schedule parsing is simplified: only the "hour field == '*'" (hourly)
#     and "day-of-month field in {'*','?'}" (daily) cases are recognized precisely; any other
#     cron pattern (e.g. step intervals such as "*/6") falls back to a conservative 720-hour
#     (monthly) estimate, matching the Sentinel policy's own fallback for unrecognized cron
#     shapes.
# These checks resolve correctly once attribute values are known (existing resources, or
# resources already applied in a prior run); for brand-new resources created in the same
# plan, cross-references to not-yet-known attributes (e.g. a new backup plan's id/arn) may
# not resolve until apply time.

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "dynamo-db-recovery-point-created-enforcement-level" {
  type    = string
  default = "advisory"
}

# backup_period_days refers to the maximum number of days since the last backup.
# Kept in effect unless recovery_point_age_value/recovery_point_age_unit are explicitly customized.
input "dynamo-db-recovery-point-created-backup_period_days" {
  type    = number
  default = 1
}

# Tags of the DynamoDB tables for the rule to check, in JSON format {"tagkey":"tagValue"}.
input "dynamo-db-recovery-point-created-resource_tags" {
  type    = string
  default = ""
}

# Name of the DynamoDB table for the rule to check.
input "dynamo-db-recovery-point-created-resource_id" {
  type    = string
  default = ""
}

# Numerical value for maximum allowed recovery point age. No more than 744 for hours, 31 for days.
input "dynamo-db-recovery-point-created-recovery_point_age_value" {
  type    = number
  default = 1
}

# Unit of time for maximum allowed recovery point age. Accepted values: 'hours', 'days'.
input "dynamo-db-recovery-point-created-recovery_point_age_unit" {
  type    = string
  default = "days"
}

locals {
  # Keep the legacy backup_period_days input effective unless the AWS Config style
  # recovery point parameters are explicitly customized away from their defaults.
  ddbrp_recovery_params_customized = input.dynamo-db-recovery-point-created-recovery_point_age_value != 1 || input.dynamo-db-recovery-point-created-recovery_point_age_unit != "days"

  ddbrp_required_hours = local.ddbrp_recovery_params_customized ? (
    input.dynamo-db-recovery-point-created-recovery_point_age_unit == "hours" ? input.dynamo-db-recovery-point-created-recovery_point_age_value : input.dynamo-db-recovery-point-created-recovery_point_age_value * 24
  ) : input.dynamo-db-recovery-point-created-backup_period_days * 24

  # Reverse-reference pattern: cache all AWS Backup plans/selections once at plan time so
  # each aws_dynamodb_table resource can check whether it is covered by a compliant one.
  ddbrp_all_backup_plans      = core::getresources("aws_backup_plan", {})
  ddbrp_all_backup_selections = core::getresources("aws_backup_selection", {})

  # For every backup plan, determine whether ANY of its rules has a schedule frequency
  # (in hours) that is less than or equal to the required maximum recovery point age.
  ddbrp_plan_compliance = [for p in local.ddbrp_all_backup_plans : {
    id   = core::try(p.id, "")
    arn  = core::try(p.arn, "")
    name = core::try(p.name, "")
    compliant = core::anytrue([for r in (core::try(p.rule, null) == null ? [] : p.rule) : (
      core::startswith(core::try(r.schedule, ""), "rate(") ? (
        core::contains_substring(core::try(r.schedule, ""), "hour")
        ? core::try(core::parseint(core::try(core::regex("[0-9]+", core::try(r.schedule, "")), "720"), 10), 720)
        : core::try(core::parseint(core::try(core::regex("[0-9]+", core::try(r.schedule, "")), "30"), 10), 30) * 24
      ) : core::startswith(core::try(r.schedule, ""), "cron(") ? (
        core::try(core::split(" ", core::try(r.schedule, ""))[1], "*") == "*"
        ? 1
        : (
          core::try(core::split(" ", core::try(r.schedule, ""))[2], "*") == "*" ||
          core::try(core::split(" ", core::try(r.schedule, ""))[2], "*") == "?"
          ) ? 24 : 720
      ) : 720
    ) <= local.ddbrp_required_hours])
  }]

  ddbrp_compliant_plan_ids   = [for p in local.ddbrp_plan_compliance : p.id if p.compliant]
  ddbrp_compliant_plan_arns  = [for p in local.ddbrp_plan_compliance : p.arn if p.compliant]
  ddbrp_compliant_plan_names = [for p in local.ddbrp_plan_compliance : p.name if p.compliant]
}

resource_policy "aws_dynamodb_table" "recovery_point_created" {
  # Apply the optional resource_id / resource_tags filters: non-matching tables are skipped
  # entirely (not reported as violations), mirroring the Sentinel policy's filter stage.
  filter = (
    (input.dynamo-db-recovery-point-created-resource_id == "" ? true : core::try(attrs.name, "") == input.dynamo-db-recovery-point-created-resource_id)
    &&
    (
      input.dynamo-db-recovery-point-created-resource_tags == "" ? true :
      core::alltrue([
        for k, v in core::try(core::jsondecode(input.dynamo-db-recovery-point-created-resource_tags), {}) :
        core::try(core::try(attrs.tags, {})[k], "__missing__") == v
      ])
    )
  )

  locals {
    table_name = core::try(attrs.name, "")
    table_arn  = core::try(attrs.arn, "")
    table_tags = core::try(attrs.tags, {})

    # Point-in-time recovery is compliant if ANY point_in_time_recovery block has enabled = true.
    # Read the enabled leaf directly: the block has computed fields, so iterating over the
    # whole block is unknown at plan time.
    pitr_enabled = core::try(attrs.point_in_time_recovery[0].enabled, false) == true

    # A backup selection "covers" this table when its resources list references the table
    # (wildcard, exact ARN, exact name, ARN suffix, or generic DynamoDB wildcard ARN pattern)
    # or its selection_tag entries all match the table's tags.
    has_compliant_selection = core::anytrue([
      for sel in local.ddbrp_all_backup_selections : (
        (
          core::anytrue([
            for ref in (core::try(sel.resources, null) == null ? [] : sel.resources) :
            ref == "*" ||
            core::endswith(ref, ":table/${local.table_name}") ||
            (local.table_arn != "" && ref == local.table_arn) ||
            (local.table_name != "" && ref == local.table_name) ||
            core::try(core::regex("^arn:aws:dynamodb:.*:table/\\*$", core::lower(ref)), null) != null
          ])
          ||
          (
            core::length((core::try(sel.selection_tag, null) == null ? [] : sel.selection_tag)) > 0 &&
            core::alltrue([
              for st in (core::try(sel.selection_tag, null) == null ? [] : sel.selection_tag) :
              core::try(st.type, "STRINGEQUALS") == "STRINGEQUALS" &&
              core::try(local.table_tags[core::try(st.key, "")], "__missing__") == core::try(st.value, "")
            ])
          )
        )
        &&
        (
          core::contains(local.ddbrp_compliant_plan_ids, core::try(sel.plan_id, "")) ||
          core::contains(local.ddbrp_compliant_plan_arns, core::try(sel.plan_id, "")) ||
          core::contains(local.ddbrp_compliant_plan_names, core::try(sel.plan_id, ""))
        )
      )
    ])

    is_backup_compliant = local.pitr_enabled ? true : local.has_compliant_selection
  }

  enforcement_level = input.dynamo-db-recovery-point-created-enforcement-level
  enforce {
    condition     = local.is_backup_compliant
    error_message = "DynamoDB table '${local.table_name}' does not have point-in-time recovery enabled and is not associated with a compliant AWS Backup plan scheduled within the required ${local.ddbrp_required_hours} hour(s)."
  }
}
