# Copyright IBM Corp. 2026

# Elasticsearch domain error logging to CloudWatch Logs should be enabled

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "elasticsearch-logs-to-cloudwatch-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_elasticsearch_domain" "error_logging_enabled" {
    enforcement_level = input.elasticsearch-logs-to-cloudwatch-enforcement-level

    locals {
        es_log_type = "ES_APPLICATION_LOGS"
        log_publishing_options_raw = core::try(attrs.log_publishing_options, null)
        log_publishing_options = local.log_publishing_options_raw != null ? local.log_publishing_options_raw : []
        
        has_app_logs = core::length([
          for opt in local.log_publishing_options : opt
          if core::try(opt.log_type, "") == local.es_log_type &&
            core::try(opt.enabled, true) == true &&
            core::try(opt.cloudwatch_log_group_arn, "") != ""
        ]) > 0
    }

    enforce {
        condition = local.has_app_logs == true
        error_message = "Elasticsearch domain must have ES_APPLICATION_LOGS enabled and configured with a valid cloudwatch_log_group_arn in log_publishing_options to send error logs to CloudWatch Logs"
    }
}
