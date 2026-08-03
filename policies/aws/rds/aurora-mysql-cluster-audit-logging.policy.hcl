# Copyright IBM Corp. 2026

# RDS.45 - Aurora MySQL DB clusters should have audit logging enabled.

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "aurora-mysql-cluster-audit-logging-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_rds_cluster" "audit_logging_configured" {
  enforcement_level = input.aurora-mysql-cluster-audit-logging-enforcement-level
  filter = core::try(attrs.engine, "") == "aurora-mysql"

  locals {
    param_group_name = core::try(attrs.db_cluster_parameter_group_name, "")
    cloudwatch_logs = core::try(attrs.enabled_cloudwatch_logs_exports, [])
    audit_log_exported = core::contains(local.cloudwatch_logs, "audit")
  }

  enforce {
    condition = local.param_group_name != ""
    error_message = "Aurora MySQL cluster must have a DB cluster parameter group associated. Set 'db_cluster_parameter_group_name' to configure audit logging. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-45 for more details."
  }

  enforce {
    condition = local.audit_log_exported
    error_message = "Aurora MySQL cluster must export 'audit' logs to CloudWatch. Add 'audit' to 'enabled_cloudwatch_logs_exports' list. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-45 for more details."
  }
}

resource_policy "aws_rds_cluster" "audit_logging_enabled" {
  enforcement_level = input.aurora-mysql-cluster-audit-logging-enforcement-level
  filter = (
    core::try(attrs.engine, "") == "aurora-mysql" &&
    core::try(attrs.db_cluster_parameter_group_name, "") != ""
  )

  connected "aws_rds_cluster_parameter_group" {
    min_instances = 1

    connection {
      subject   = "db_cluster_parameter_group_name"
      connected = "name"
    }

    enforce {
      condition = core::try([
        for param in core::try(connected.aws_rds_cluster_parameter_group.parameter, []) : param.value
        if param.name == "server_audit_logging"
      ][0], "") == "1"
      error_message = "Aurora MySQL cluster parameter group must have 'server_audit_logging' set to '1'. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-45 for more details."
    }

    enforce {
      condition = core::try([
        for param in core::try(connected.aws_rds_cluster_parameter_group.parameter, []) : param.value
        if param.name == "server_audit_events"
      ][0], "") != ""
      error_message = "Aurora MySQL cluster parameter group must have 'server_audit_events' configured with audit events (e.g., 'CONNECT,QUERY,QUERY_DCL,QUERY_DDL,QUERY_DML'). Current value is empty or not set. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-45 for more details."
    }
  }
}
