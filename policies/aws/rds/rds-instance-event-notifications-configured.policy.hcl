# Copyright IBM Corp. 2026

# RDS.20 - Existing RDS event notification subscriptions should be configured for critical database instance events.

policy {}

resource_policy "aws_db_event_subscription" "critical_events_configured" {
    filter = core::try(attrs.source_type, "") == "db-instance" || core::try(attrs.source_type, "") == ""

    locals {
        event_categories = core::try(attrs.event_categories, [])
        is_enabled = core::try(attrs.enabled, true)
        
        has_maintenance = core::contains(local.event_categories, "maintenance")
        has_config_change = core::contains(local.event_categories, "configuration change")
        has_failure = core::contains(local.event_categories, "failure")
        
        all_categories_present = local.has_maintenance && local.has_config_change && local.has_failure
    }

    enforce {
        condition = local.event_categories == [] || (local.is_enabled && local.all_categories_present)
        error_message = "RDS event subscription must include all critical event categories: 'maintenance', 'configuration change', and 'failure'. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-20 for more details."
    }
}
