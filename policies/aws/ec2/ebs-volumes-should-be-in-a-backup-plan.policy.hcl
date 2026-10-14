# Copyright IBM Corp. 2026

# EBS volumes should be covered by a backup plan

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.65.0, < 7.0.0"
    }
  }
}

input "ebs-volumes-should-be-in-a-backup-plan-enforcement-level" {
  type    = string
  default = "advisory"
}

# When enabled, also require Vault Lock on the vaults used by matching backup plans.
input "ebsBackupVaultLockCheck" {
  type    = bool
  default = false
}

locals {
  ebs_all_backup_selections = core::getresources("aws_backup_selection", {})
  ebs_all_backup_plans      = core::getresources("aws_backup_plan", {})
  ebs_all_vault_locks       = core::getresources("aws_backup_vault_lock_configuration", {})
  ebs_locked_vault_names = core::try([
    for lock in local.ebs_all_vault_locks :
    core::try(lock.backup_vault_name, "")
    if core::try(lock.backup_vault_name, "") != ""
  ], [])
}

# Direct ARN matching cannot cover a volume whose ARN is computed in the same plan.
# Use a tag-based backup selection for new volumes whose ARN is not yet known.
resource_policy "aws_ebs_volume" "ebs_volumes_should_be_in_a_backup_plan" {
  enforcement_level = input.ebs-volumes-should-be-in-a-backup-plan-enforcement-level

  locals {
    volume_arn_raw = core::try(attrs.arn, null)
    volume_arn     = local.volume_arn_raw != null ? local.volume_arn_raw : ""
    volume_tags    = core::try(attrs.tags, null) != null ? attrs.tags : {}

    direct_arn_selections = core::try([
      for selection in local.ebs_all_backup_selections : selection
      if local.volume_arn != ""
        && core::contains(
          core::try(selection.resources, null) != null ? core::try(selection.resources, []) : [],
          local.volume_arn
        )
    ], [])

    tag_based_selections = core::try([
      for selection in local.ebs_all_backup_selections : selection
      if (
        core::length([
          for tag in (core::try(selection.selection_tag, null) != null ? selection.selection_tag : []) : tag
          if core::try(tag.key, null) != null
            && core::try(tag.value, null) != null
            && core::try(local.volume_tags[tag.key], null) != null
            && core::try(local.volume_tags[tag.key], "") == core::try(tag.value, "")
        ]) > 0
        || core::length([
          for condition in (core::try(selection.condition, null) != null ? selection.condition : []) : condition
          if core::length([
            for equals in (core::try(condition.string_equals, null) != null ? condition.string_equals : []) : equals
            if core::try(equals.key, null) != null
              && core::try(equals.value, null) != null
              && (
                (
                  core::try(local.volume_tags[equals.key], null) != null
                  && core::try(local.volume_tags[equals.key], "") == core::try(equals.value, "")
                )
                || (
                  core::length(core::split("/", equals.key)) > 1
                  && core::try(local.volume_tags[core::split("/", equals.key)[1]], null) != null
                  && core::try(local.volume_tags[core::split("/", equals.key)[1]], "") == core::try(equals.value, "")
                )
              )
          ]) > 0
        ]) > 0
      )
    ], [])

    matching_selections = core::try(
      core::concat(local.direct_arn_selections, local.tag_based_selections),
      []
    )
    is_in_backup = core::length(local.matching_selections) > 0

    associated_vault_names = core::try(core::flatten([
      for selection in local.matching_selections :
      core::try(core::flatten([
        for plan in local.ebs_all_backup_plans :
        core::try([
          for rule in core::try(plan.rule, []) : core::try(rule.target_vault_name, "")
          if core::try(rule.target_vault_name, "") != ""
        ], [])
        if core::try(plan.id, "") != "" && core::try(plan.id, "") == core::try(selection.plan_id, "")
      ]), [])
    ]), [])

    unlocked_vault_names = core::try([
      for vault_name in local.associated_vault_names : vault_name
      if vault_name != "" && !core::contains(local.ebs_locked_vault_names, vault_name)
    ], [])
    all_vaults_locked = core::length(local.unlocked_vault_names) == 0
  }

  enforce {
    condition     = local.is_in_backup
    error_message = "EBS volumes should be included in AWS Backup plans through a matching ARN or tag-based aws_backup_selection."
  }

  enforce {
    condition     = !input.ebsBackupVaultLockCheck || !local.is_in_backup || local.all_vaults_locked
    error_message = "EBS volumes are protected by backup plan(s) whose vault(s) do not have Vault Lock enabled. Configure aws_backup_vault_lock_configuration for each associated vault when backupVaultLockCheck is true."
  }
}
