# RDS.19 - Existing RDS event notification subscriptions should be configured for critical cluster events.

policy {}

resource_policy "aws_db_event_subscription" "cluster_event_notifications" {
    filter = core::try(attrs.source_type, "") == "db-cluster" || core::try(attrs.source_type, "") == ""
    locals {
        event_categories = core::try(attrs.event_categories, [])
        
        has_maintenance = core::contains(local.event_categories, "maintenance")
        has_failure = core::contains(local.event_categories, "failure")
        
        is_enabled = core::try(attrs.enabled, true)
    }

    enforce {
        condition = local.event_categories == [] || (local.is_enabled && local.has_maintenance && local.has_failure)
        error_message = "RDS event subscription for db-cluster must be enabled for both 'maintenance' and 'failure' event_categories. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-19 for more details."
    }
}
