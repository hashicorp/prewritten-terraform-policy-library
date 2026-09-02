# Copyright IBM Corp. 2026

# MSK connectors should have logging enabled

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.8.0, < 7.0.0"
    }
  }
}

input "msk-connect-connector-logging-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_mskconnect_connector" "logging_enabled" {
    enforcement_level = input.msk-connect-connector-logging-enabled-enforcement-level

    locals {
        log_delivery_raw = core::try(attrs.log_delivery, null)
        log_delivery = local.log_delivery_raw != null ? local.log_delivery_raw : []
        
        # Extract worker_log_delivery configuration
        worker_log_delivery_raw = core::try(local.log_delivery[0].worker_log_delivery, null)
        worker_log_delivery = local.worker_log_delivery_raw != null ? local.worker_log_delivery_raw : []
        
        # Check CloudWatch Logs configuration
        cloudwatch_logs_raw = core::try(local.worker_log_delivery[0].cloudwatch_logs, null)
        cloudwatch_logs = local.cloudwatch_logs_raw != null ? local.cloudwatch_logs_raw : []
        cloudwatch_enabled = core::try(local.cloudwatch_logs[0].enabled, false)
        cloudwatch_log_group = core::try(local.cloudwatch_logs[0].log_group, "")
        
        # Check Firehose configuration
        firehose_raw = core::try(local.worker_log_delivery[0].firehose, null)
        firehose = local.firehose_raw != null ? local.firehose_raw : []
        firehose_enabled = core::try(local.firehose[0].enabled, false)
        firehose_delivery_stream = core::try(local.firehose[0].delivery_stream, "")
        
        # Check S3 configuration
        s3_raw = core::try(local.worker_log_delivery[0].s3, null)
        s3 = local.s3_raw != null ? local.s3_raw : []
        s3_enabled = core::try(local.s3[0].enabled, false)
        s3_bucket = core::try(local.s3[0].bucket, "")
        
        # Check if at least one logging destination is enabled
        has_logging_enabled = (local.cloudwatch_enabled && local.cloudwatch_log_group != "") || (local.firehose_enabled && local.firehose_delivery_stream != "") || (local.s3_enabled && local.s3_bucket != "")
    }

    # Enforce: At least one logging destination (CloudWatch OR Firehose OR S3) must be enabled
    enforce {
        condition = local.has_logging_enabled
        error_message = "MSK connector must have at least one logging destination enabled (CloudWatch Logs, Firehose, or S3)"
    }
}
