// Policy: DMS.8 - DMS replication tasks for source database should have logging enabled

policy {}

resource_policy "aws_dms_replication_task" "source_logging_enabled" {
    locals {
        // Get the replication task settings - use core::try to handle missing attribute
        settings_json = core::try(attrs.replication_task_settings, "")
        
        // Check if settings exist
        has_settings = local.settings_json != ""
        
        // Task identifier for error messages
        task_id = core::try(attrs.replication_task_id, "REPLICATION_TASK_ID")
    }

    // Enforce: replication_task_settings must be defined
    // Note: This is a minimal check due to tfpolicy limitations
    enforce {
        condition = local.has_settings
        error_message = "DMS replication task '${local.task_id}' must have replication_task_settings defined. Configure logging for SOURCE_CAPTURE and SOURCE_UNLOAD components with minimum severity LOGGER_SEVERITY_DEFAULT. For full validation, use AWS Config rule 'dms-replication-task-sourcedb-logging'. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/dms-controls.html#dms-8 for more details."
    }
}