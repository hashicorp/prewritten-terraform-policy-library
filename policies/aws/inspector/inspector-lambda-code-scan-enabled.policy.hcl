# Copyright IBM Corp. 2026

# Inspector.3 - Amazon Inspector Lambda Code Scanning Should Be Enabled.

policy {}

input "inspector-lambda-code-scan-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_inspector2_enabler" "lambda_code_scanning_enabled" {
    enforcement_level = input.inspector-lambda-code-scan-enabled-enforcement-level
    filter = attrs.resource_types != null

    locals {
        resource_types = core::try(attrs.resource_types, [])
    }

    enforce {
        condition = core::contains(local.resource_types, "LAMBDA_CODE")
        error_message = "Amazon Inspector Lambda Code scanning must be enabled. Add 'LAMBDA_CODE' to the resource_types list to enable Lambda Code scanning. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/inspector-controls.html#inspector-3 for more details."
    }
}

resource_policy "aws_inspector2_organization_configuration" "lambda_code_org_scanning_enabled" {
    enforcement_level = input.inspector-lambda-code-scan-enabled-enforcement-level
    filter = core::try(attrs.auto_enable, null) != null && core::length(core::try(attrs.auto_enable, [])) > 0
    enforce {
        condition = core::try(attrs.auto_enable[0].lambda, false) == true && core::try(attrs.auto_enable[0].lambda_code, false) == true
        error_message = "Amazon Inspector Lambda Code scanning must be enabled. Set 'auto_enable.lambda = true' and 'auto_enable.lambda_code = true' to enable Lambda Code scanning. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/inspector-controls.html#inspector-3 for more details."
    }
}
