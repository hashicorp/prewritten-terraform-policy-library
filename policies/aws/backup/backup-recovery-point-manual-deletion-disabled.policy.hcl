# Copyright IBM Corp. 2026

# AWS Backup vaults should prevent manual deletion of recovery points

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "backup-recovery-point-manual-deletion-disabled-enforcement-level" {
  type    = string
  default = "advisory"
}

input "backup-recovery-point-manual-deletion-disabled-excluded_principal_arns" {
  type    = list(string)
  default = []
}

resource_policy "aws_backup_vault" "backup_recovery_point_manual_deletion_disabled" {
  locals {
    required_delete_action = "deleterecoverypoint"
    required_update_action = "updaterecoverypointlifecycle"
    required_put_action    = "putbackupvaultaccesspolicy"

    vault_policies = core::getresources("aws_backup_vault_policy", {
      backup_vault_name = attrs.name
    })
    has_policy = core::length(local.vault_policies) > 0

    policy_json_raw = core::try(local.vault_policies[0].policy, null)
    policy_json     = local.policy_json_raw == null ? "" : local.policy_json_raw

    policy_doc     = core::try(core::jsondecode(local.policy_json), {})
    statements_raw = core::try(local.policy_doc.Statement, null)
    statements     = local.statements_raw == null ? [] : local.statements_raw

    deny_statements = [for s in local.statements : s if core::try(s.Effect, "") == "Deny" && core::try(s.Condition, null) == null]
    deny_count      = core::length(local.deny_statements)

    deny_actions = [for s in local.deny_statements :
      core::try([for a in core::try(s.Action, []) : a], [core::try(s.Action, "")])
    ]

    deny_has_delete = [for acts in local.deny_actions :
      core::length([for a in acts : a if core::contains(["*", "backup:*"], core::lower(a)) || core::endswith(core::lower(a), local.required_delete_action)]) > 0
    ]
    deny_has_update = [for acts in local.deny_actions :
      core::length([for a in acts : a if core::contains(["*", "backup:*"], core::lower(a)) || core::endswith(core::lower(a), local.required_update_action)]) > 0
    ]
    deny_has_put = [for acts in local.deny_actions :
      core::length([for a in acts : a if core::contains(["*", "backup:*"], core::lower(a)) || core::endswith(core::lower(a), local.required_put_action)]) > 0
    ]

    deny_principal_aws_raw = [for s in local.deny_statements : core::try(s.Principal.AWS, null)]
    deny_principals = [for p in local.deny_principal_aws_raw :
      p == null ? [] : core::try([for x in p : x], [p])
    ]

    deny_all_principals_excluded = [for plist in local.deny_principals :
      core::length(plist) > 0 && core::length([for p in plist : p if core::contains(input.backup-recovery-point-manual-deletion-disabled-excluded_principal_arns, p)]) == core::length(plist)
    ]

    deny_compliant = [for i in core::range(local.deny_count) :
      local.deny_has_delete[i] && local.deny_has_update[i] && local.deny_has_put[i] && !local.deny_all_principals_excluded[i]
    ]

    has_compliant_deny = core::length([for c in local.deny_compliant : c if c]) > 0

    is_compliant = local.has_policy && local.has_compliant_deny
  }

  enforcement_level = input.backup-recovery-point-manual-deletion-disabled-enforcement-level
  enforce {
    condition     = local.is_compliant
    error_message = "Backup vault '${attrs.name}' does not have a compliant resource-based policy. Backup vault must have a resource-based policy with a Deny statement covering backup:DeleteRecoveryPoint, backup:UpdateRecoveryPointLifecycle, and backup:PutBackupVaultAccessPolicy to prevent manual deletion of recovery points."
  }
}
