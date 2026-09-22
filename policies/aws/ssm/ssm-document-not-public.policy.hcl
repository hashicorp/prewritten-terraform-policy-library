# Copyright IBM Corp. 2026

# SSM documents should not be public

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.65.0, < 7.0.0"
    }
  }
}

input "ssm-document-not-public-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_ssm_document" "ssm_document_not_public" {
    enforcement_level = input.ssm-document-not-public-enforcement-level
    locals {

        # Get the owner of the document (computed attribute)
        owner = core::try(attrs.owner, "")
        
        # Get permissions configuration if it exists.
        # `permissions` is a map(string) attribute (not a list of blocks); `account_ids`
        # is a single comma-separated string, e.g. "111111111111,All".
        permissions_raw   = core::try(attrs.permissions, null)
        permissions       = local.permissions_raw != null ? local.permissions_raw : {}
        permissions_type  = core::try(local.permissions.type, "")
        account_ids_null  = core::try(local.permissions.account_ids, null)
        account_ids_raw   = local.account_ids_null != null ? local.account_ids_null : ""
        account_ids       = local.account_ids_raw != "" ? core::split(",", local.account_ids_raw) : []
        
        # Check if document is owned by Self (the account)
        is_self_owned = local.owner == "Self"
        
        # Check if permissions contain "All" (public access)
        is_public = local.permissions_type == "Share" && core::contains(local.account_ids, "All")
    }

    # Only evaluate documents owned by Self
    filter = local.is_self_owned

    enforce {
        condition = !local.is_public
        error_message = "SSM document is publicly accessible. Documents owned by 'Self' must not have 'All' in permissions.account_ids. Current account_ids: ${core::join(", ", local.account_ids)}"
    }
}
