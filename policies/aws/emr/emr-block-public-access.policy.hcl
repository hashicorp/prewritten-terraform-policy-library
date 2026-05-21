# EMR.2 - Amazon EMR block public access setting should be enabled.

policy {}

resource_policy "aws_emr_block_public_access_configuration" "block-public-access" {
    locals {
        block_security_group_enabled = core::try(attrs.block_public_security_group_rules, true)
        is_permitted_range = local.block_security_group_enabled ? (core::try(attrs.permitted_public_security_group_rule_range.min_range, 0) == 22 && core::try(attrs.permitted_public_security_group_rule_range.max_range, 0) == 22) : false
    }

    enforce {
        condition = local.block_security_group_enabled && local.is_permitted_range
        error_message = "The EMR block public access configuration does not have the correct settings. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/emr-controls.html#emr-2 for more details."
    }
}