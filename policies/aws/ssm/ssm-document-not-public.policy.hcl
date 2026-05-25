<<<<<<< HEAD
// Policy: SSM.4 - SSM documents should not be public
=======
# Policy: SSM.4 - SSM documents should not be public
>>>>>>> origin/main

policy {}

resource_policy "aws_ssm_document" "ssm_document_not_public" {
    locals {
<<<<<<< HEAD
        // Get the owner of the document (computed attribute)
        owner = core::try(attrs.owner, "")
        
        // Get permissions configuration if it exists
        permissions = core::try(attrs.permissions, null)
        
        // Check if permissions exist and extract account_ids
        has_permissions = local.permissions != null
        account_ids = local.has_permissions ? core::try(local.permissions.account_ids, []) : []
        
        // Check if document is owned by Self (the account)
        is_self_owned = local.owner == "Self"
        
        // Check if permissions contain "All" (public access)
        is_public = local.has_permissions && core::contains(local.account_ids, "All")
    }

    // Only evaluate documents owned by Self
=======
        # Get the owner of the document (computed attribute)
        owner = core::try(attrs.owner, "")
        
        # Get permissions configuration if it exists
        permissions = core::try(attrs.permissions, null)
        
        # Check if permissions exist and extract account_ids
        has_permissions = local.permissions != null
        account_ids = local.has_permissions ? core::try(local.permissions.account_ids, []) : []
        
        # Check if document is owned by Self (the account)
        is_self_owned = local.owner == "Self"
        
        # Check if permissions contain "All" (public access)
        is_public = local.has_permissions && core::contains(local.account_ids, "All")
    }

    # Only evaluate documents owned by Self
>>>>>>> origin/main
    filter = local.is_self_owned

    enforce {
        condition = !local.is_public
        error_message = "SSM document is publicly accessible. Documents owned by 'Self' must not have 'All' in permissions.account_ids. Current account_ids: ${core::join(", ", local.account_ids)} . Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ssm-controls.html#ssm-4 for more details."
    }
}
