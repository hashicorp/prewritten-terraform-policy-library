# Inspector.1 - Amazon Inspector EC2 Scanning Should Be Enabled.

policy {}

resource_policy "aws_inspector2_enabler" "ec2_scanning_enabled" {
    filter = attrs.resource_types != null

    locals {
        resource_types = core::try(attrs.resource_types, [])
    }

    enforce {
        condition = core::contains(local.resource_types, "EC2")
        error_message = "Amazon Inspector EC2 scanning must be enabled. Add 'EC2' to the resource_types list to enable EC2 scanning. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/inspector-controls.html#inspector-1 for more details."
    }
}

resource_policy "aws_inspector2_organization_configuration" "ec2_org_scanning_enabled" {
    filter = core::try(attrs.auto_enable, null) != null && core::length(core::try(attrs.auto_enable, [])) > 0
    enforce {
        condition = core::try(attrs.auto_enable[0].ec2, false) == true
        error_message = "Amazon Inspector EC2 scanning must be enabled. Set 'auto_enable.ec2 = true' to enable EC2 scanning. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/inspector-controls.html#inspector-1 for more details."
    }
}
