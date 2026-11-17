# Copyright IBM Corp. 2026

# Existing RDS event notification subscriptions should be configured for critical cluster events

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.65.0, < 7.0.0"
    }
  }
}

input "rds-cluster-event-notifications-configured-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_db_event_subscription" "cluster_event_notifications" {
    enforcement_level = input.rds-cluster-event-notifications-configured-enforcement-level
    filter = core::try(attrs.source_type, "") == "db-cluster" || core::try(attrs.source_type, "") == ""
    locals {
        raw_event_categories = core::try(attrs.event_categories, null)
        event_categories = local.raw_event_categories != null ? local.raw_event_categories : []
        
        has_maintenance = core::contains(local.event_categories, "maintenance")
        has_failure = core::contains(local.event_categories, "failure")
        
        is_enabled = core::try(attrs.enabled, true)
    }

    enforce {
        condition = local.is_enabled && (core::length(local.event_categories) == 0 || (local.has_maintenance && local.has_failure))
        error_message = "RDS event subscription for db-cluster must be enabled for both 'maintenance' and 'failure' event_categories"
    }
}
