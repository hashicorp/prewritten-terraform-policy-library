# Copyright IBM Corp. 2026

# RDS.1 - RDS snapshot should be private.

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0, < 7.0.0"
    }
  }
}

input "rds-snapshots-public-prohibited-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_db_snapshot" "no_public_snapshots" {
    enforcement_level = input.rds-snapshots-public-prohibited-enforcement-level
    locals {
        shared_accounts_list = core::try(attrs.shared_accounts, [])
        has_shared_accounts = local.shared_accounts_list != null && local.shared_accounts_list != []
        is_public = local.has_shared_accounts ? core::contains(local.shared_accounts_list, "all") : false
    }

    enforce {
        condition = !local.is_public
        error_message = "RDS DB snapshot is configured as public. The 'shared_accounts' attribute contains 'all', which makes the snapshot accessible to every AWS account. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-1 for more details."
    }
}

resource_policy "aws_db_cluster_snapshot" "no_public_snapshots" {
    enforcement_level = input.rds-snapshots-public-prohibited-enforcement-level
    locals {
        shared_accounts_list = core::try(attrs.shared_accounts, [])
        has_shared_accounts = local.shared_accounts_list != null && local.shared_accounts_list != []
        is_public = local.has_shared_accounts ? core::contains(local.shared_accounts_list, "all") : false
    }

    enforce {
        condition = !local.is_public
        error_message = "RDS DB cluster snapshot is configured as public. The 'shared_accounts' attribute contains 'all', which makes the snapshot accessible to every AWS account. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-1 for more details."
    }
}
