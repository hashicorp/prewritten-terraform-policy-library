# Copyright IBM Corp. 2026

# WAF.1 - AWS WAF Classic Global Web ACL logging should be enabled

policy {}

resource_policy "aws_waf_web_acl" "logging_enabled" {
  locals {
    has_logging = core::try(attrs.logging_configuration, null) != null
    log_config = core::try(attrs.logging_configuration, [])
    has_destination = core::length(local.log_config) > 0 ? core::try(local.log_config[0].log_destination, "") != "" : false
  }

  enforce {
    condition = local.has_logging && local.has_destination
    error_message = "WAF Classic Web ACL must have logging_configuration with a valid log_destination ARN pointing to a Kinesis Firehose Delivery Stream. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/waf-controls.html#waf-1 for more details."
  }
}