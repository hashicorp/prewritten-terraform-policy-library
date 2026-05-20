# RDS.21 - RDS Event Notifications for Database Parameter Group Events.

policy {}

resource_policy "aws_db_event_subscription" "parameter_group_events" {
    filter = core::try(attrs.source_type, "") == "db-parameter-group" || core::try(attrs.source_type, "") == ""

    locals {
        event_categories = core::try(attrs.event_categories, [])
        is_enabled = core::try(attrs.enabled, true)
        
        has_config_change = core::contains(local.event_categories, "configuration change")
    }

    enforce {
        condition = local.event_categories == [] || (local.is_enabled && local.has_config_change)
        error_message = "RDS event subscription must include 'configuration change' in event_categories. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-21 for more details."
    }
}
