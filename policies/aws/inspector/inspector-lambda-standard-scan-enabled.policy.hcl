# Inspector.4 - Amazon Inspector Lambda Scanning Should Be Enabled.

policy {}

resource_policy "aws_inspector2_enabler" "lambda_scanning_enabled" {
    filter = attrs.resource_types != null

    locals {
        resource_types = core::try(attrs.resource_types, [])
    }

    enforce {
        condition = core::contains(local.resource_types, "LAMBDA")
        error_message = "Amazon Inspector Lambda scanning must be enabled. Add 'LAMBDA' to the resource_types list to enable Lambda scanning. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/inspector-controls.html#inspector-4 for more details."
    }
}

resource_policy "aws_inspector2_organization_configuration" "lambda_org_scanning_enabled" {
    filter = core::try(attrs.auto_enable, null) != null && core::length(core::try(attrs.auto_enable, [])) > 0
    enforce {
        condition = core::try(attrs.auto_enable[0].lambda, false) == true
        error_message = "Amazon Inspector Lambda scanning must be enabled. Set 'auto_enable.lambda = true' to enable Lambda scanning. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/inspector-controls.html#inspector-4 for more details."
    }
}
