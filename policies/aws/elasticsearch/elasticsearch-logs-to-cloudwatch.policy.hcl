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
        
        has_app_logs = core::try(local.log_publishing_options[0].log_type, "") == local.es_log_type
        is_enabled = core::try(local.log_publishing_options[0].enabled, true)
        has_log_group = core::try(local.log_publishing_options[0].cloudwatch_log_group_arn, "") != ""
    }

    enforce {
        condition = local.has_app_logs == true
        error_message = "Elasticsearch domain does not have ES_APPLICATION_LOGS configured. Add log_publishing_options block with log_type = 'ES_APPLICATION_LOGS' to enable error logging"
    }

    enforce {
        condition = local.is_enabled
        error_message = "Elasticsearch domain has ES_APPLICATION_LOGS configured but it is disabled. Set 'enabled = true' or remove the enabled attribute (defaults to true)"
    }

    enforce {
        condition = local.has_log_group
        error_message = "Elasticsearch domain has ES_APPLICATION_LOGS configured but missing cloudwatch_log_group_arn. Specify a valid CloudWatch log group ARN to receive error logs"
    }
}
