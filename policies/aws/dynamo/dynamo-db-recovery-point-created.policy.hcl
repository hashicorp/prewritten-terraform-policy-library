# Copyright IBM Corp. 2026

# DynamoDB tables should have a recent recovery point

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

input "dynamo-db-recovery-point-created-backup_period_days" {
  type    = number
  default = 1
}

input "dynamo-db-recovery-point-created-resource_tags" {
  type    = string
  default = ""
}

input "dynamo-db-recovery-point-created-resource_id" {
  type    = string
  default = ""
}

input "dynamo-db-recovery-point-created-recovery_point_age_value" {
  type    = number
  default = 1
}

input "dynamo-db-recovery-point-created-recovery_point_age_unit" {
  type    = string
  default = "days"
}

locals {
  ddbrp_recovery_params_customized = input.dynamo-db-recovery-point-created-recovery_point_age_value != 1 || input.dynamo-db-recovery-point-created-recovery_point_age_unit != "days"

  ddbrp_required_hours = local.ddbrp_recovery_params_customized ? (
    input.dynamo-db-recovery-point-created-recovery_point_age_unit == "hours" ? input.dynamo-db-recovery-point-created-recovery_point_age_value : input.dynamo-db-recovery-point-created-recovery_point_age_value * 24
  ) : input.dynamo-db-recovery-point-created-backup_period_days * 24

  ddbrp_all_backup_plans      = core::getresources("aws_backup_plan", {})
  ddbrp_all_backup_selections = core::getresources("aws_backup_selection", {})

  ddbrp_plan_rules = [for p in local.ddbrp_all_backup_plans : {
    id   = core::try(p.id, null) == null ? "" : p.id
    arn  = core::try(p.arn, null) == null ? "" : p.arn
    name = core::try(p.name, null) == null ? "" : p.name
    rules = [for r in(core::try(p.rule, null) == null ? [] : p.rule) : {
      kind  = core::startswith(core::try(r.schedule, ""), "rate(") ? "rate" : (core::startswith(core::try(r.schedule, ""), "cron(") ? "cron" : "")
      parts = core::split(" ", core::trimspace(core::split(")", core::try(core::split("(", core::try(r.schedule, ""))[1], ""))[0]))
    }]
  }]

  ddbrp_plan_hours = [for p in local.ddbrp_plan_rules : {
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

  ddbrp_compliant_plans      = [for p in local.ddbrp_plan_hours : p if core::length([for h in p.hours : h if h <= local.ddbrp_required_hours]) > 0]
  ddbrp_compliant_plan_ids   = [for p in local.ddbrp_compliant_plans : p.id]
  ddbrp_compliant_plan_arns  = [for p in local.ddbrp_compliant_plans : p.arn]
  ddbrp_compliant_plan_names = [for p in local.ddbrp_compliant_plans : p.name]
}

resource_policy "aws_dynamodb_table" "recovery_point_created" {
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

    has_compliant_selection = core::anytrue([
      for sel in local.ddbrp_all_backup_selections : (
        (
          core::anytrue([
            for ref in(core::try(sel.resources, null) == null ? [] : sel.resources) :
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
              for st in(core::try(sel.selection_tag, null) == null ? [] : sel.selection_tag) :
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

    is_backup_compliant = local.has_compliant_selection
  }

  enforcement_level = input.dynamo-db-recovery-point-created-enforcement-level
  enforce {
    condition     = local.is_backup_compliant
    error_message = "DynamoDB table '${local.table_name}' is not associated with a compliant AWS Backup plan scheduled within the required ${local.ddbrp_required_hours} hour(s)."
  }
}
