# Copyright IBM Corp. 2026

# Policy: DMS.10 - DMS endpoints for Neptune databases should have IAM authorization enabled

policy {}

input "dms-neptune-iam-authorization-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_dms_endpoint" "neptune_iam_authorization_required" {
    enforcement_level = input.dms-neptune-iam-authorization-enabled-enforcement-level
    # Filter to only Neptune endpoints
    filter = core::try(attrs.engine_name, "") == "neptune"

    locals {
        # Safe access to service_access_role attribute
        service_access_role = core::try(attrs.service_access_role, null)
        
        # Check if service_access_role is configured
        has_service_role = local.service_access_role != null && local.service_access_role != ""
    }

    # Enforce: service_access_role must be configured
    enforce {
        condition = local.has_service_role
        error_message = "DMS endpoint for Neptune database must have IAM authorization enabled via service_access_role parameter. Configure a valid IAM role ARN to grant authorization privileges. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/dms-controls.html#dms-10 for more details."
    }
}
