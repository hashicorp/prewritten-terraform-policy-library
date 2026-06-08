# Copyright IBM Corp. 2026

# Policy: Lambda.1 - Lambda function policies should prohibit public access

policy {}

resource_policy "aws_lambda_permission" "prohibit_public_access" {
    locals {
        principal = core::try(attrs.principal, "")

        is_public_principal = (
            local.principal == ""
            || local.principal == "*"
            || local.principal == "AWS:*"
            || local.principal == "AWS:"
            || core::try(core::length(core::regexall("\\*", local.principal)), 0) > 0
        )

        is_service_principal = core::try(core::length(core::regexall("\\.amazonaws\\.com$", local.principal)), 0) > 0

        has_source_arn        = core::try(attrs.source_arn, null) != null
        has_source_account    = core::try(attrs.source_account, null) != null
        has_principal_org_id  = core::try(attrs.principal_org_id, null) != null
        has_source_constraint = local.has_source_arn || local.has_source_account || local.has_principal_org_id

        service_principal_unconstrained = local.is_service_principal && !local.has_source_constraint
    }

    # Enforce: principal must not be a wildcard
    enforce {
        condition = !local.is_public_principal
        error_message = "Lambda permission must not allow public access via a wildcard principal. Use a specific AWS account ID, IAM principal ARN, or service principal with a source constraint. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/lambda-controls.html#lambda-1 for more details."
    }

    # Enforce: any AWS service principal must be scoped by source_arn,
    # source_account, or principal_org_id, otherwise any account can invoke.
    enforce {
        condition = !local.service_principal_unconstrained
        error_message = "Lambda permission grants invoke to an AWS service principal without any source constraint. Add 'source_arn', 'source_account', or 'principal_org_id' to limit which resource/account can trigger the function. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/lambda-controls.html#lambda-1 for more details."
    }
}
