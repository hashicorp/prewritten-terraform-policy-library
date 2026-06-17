# Copyright IBM Corp. 2026

# Policy : WAF.12 - AWS WAF rules should have CloudWatch metrics enabled

policy {}

input "wafv2-rulegroup-logging-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_wafv2_rule_group" "waf_rule_group_cloudwatch_metrics_enabled" {
  enforcement_level = input.wafv2-rulegroup-logging-enabled-enforcement-level
  locals {
    resource_name = core::try(attrs.name, "unknown")
    resource_visibility_config = core::try(attrs.visibility_config, [])
    resource_has_visibility_config = core::length(local.resource_visibility_config) > 0
    resource_cloudwatch_metrics_enabled = core::try(attrs.visibility_config[0].cloudwatch_metrics_enabled, false)

    rules = core::try(attrs.rule, [])

    rules_missing_visibility_config = [
      for rule in local.rules : rule.name
      if core::length(core::try(rule.visibility_config, [])) == 0
    ]

    rules_with_metrics_disabled = [
      for rule in local.rules : rule.name
      if core::length(core::try(rule.visibility_config, [])) > 0 && core::try(rule.visibility_config[0].cloudwatch_metrics_enabled, false) != true
    ]
  }

  enforce {
    condition = local.resource_has_visibility_config
    error_message = "WAF rule group '${local.resource_name}' must define a visibility_config block with CloudWatch metrics enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/waf-controls.html#waf-12 for more details."
  }

  enforce {
    condition = !local.resource_has_visibility_config || local.resource_cloudwatch_metrics_enabled == true
    error_message = "WAF rule group '${local.resource_name}' must set visibility_config.cloudwatch_metrics_enabled to true. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/waf-controls.html#waf-12 for more details."
  }

  enforce {
    condition = core::length(local.rules_missing_visibility_config) == 0
    error_message = "Each rule in WAF rule group '${local.resource_name}' must define visibility_config. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/waf-controls.html#waf-12 for more details."
  }

  enforce {
    condition = core::length(local.rules_missing_visibility_config) > 0 || core::length(local.rules_with_metrics_disabled) == 0
    error_message = "Each rule in WAF rule group '${local.resource_name}' must set visibility_config.cloudwatch_metrics_enabled to true. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/waf-controls.html#waf-12 for more details."
  }
}

resource_policy "aws_wafv2_web_acl" "waf_web_acl_cloudwatch_metrics_enabled" {
  enforcement_level = input.wafv2-rulegroup-logging-enabled-enforcement-level
  locals {
    resource_name = core::try(attrs.name, "unknown")
    resource_visibility_config = core::try(attrs.visibility_config, [])
    resource_has_visibility_config = core::length(local.resource_visibility_config) > 0
    resource_cloudwatch_metrics_enabled = core::try(attrs.visibility_config[0].cloudwatch_metrics_enabled, false)

    rules = core::try(attrs.rule, [])

    rules_missing_visibility_config = [
      for rule in local.rules : rule.name
      if core::length(core::try(rule.visibility_config, [])) == 0
    ]

    rules_with_metrics_disabled = [
      for rule in local.rules : rule.name
      if core::length(core::try(rule.visibility_config, [])) > 0 && core::try(rule.visibility_config[0].cloudwatch_metrics_enabled, false) != true
    ]
  }

  enforce {
    condition = local.resource_has_visibility_config
    error_message = "WAF web ACL '${local.resource_name}' must define a visibility_config block with CloudWatch metrics enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/waf-controls.html#waf-12 for more details."
  }

  enforce {
    condition = !local.resource_has_visibility_config || local.resource_cloudwatch_metrics_enabled == true
    error_message = "WAF web ACL '${local.resource_name}' must set visibility_config.cloudwatch_metrics_enabled to true. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/waf-controls.html#waf-12 for more details."
  }

  enforce {
    condition = core::length(local.rules_missing_visibility_config) == 0
    error_message = "Each rule in WAF web ACL '${local.resource_name}' must define visibility_config. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/waf-controls.html#waf-12 for more details."
  }

  enforce {
    condition = core::length(local.rules_missing_visibility_config) > 0 || core::length(local.rules_with_metrics_disabled) == 0
    error_message = "Each rule in WAF web ACL '${local.resource_name}' must set visibility_config.cloudwatch_metrics_enabled to true. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/waf-controls.html#waf-12 for more details."
  }
}
