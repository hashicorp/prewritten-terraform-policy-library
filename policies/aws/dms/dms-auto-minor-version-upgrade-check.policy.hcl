# Policy: DMS.6 - DMS replication instances should have automatic minor version upgrade enabled

policy {}

resource_policy "aws_dms_replication_instance" "auto_minor_version_upgrade_required" {
    locals {
        // Safely access auto_minor_version_upgrade attribute with default false
        auto_upgrade_enabled = core::try(attrs.auto_minor_version_upgrade, false)
    }

    enforce {
        condition = local.auto_upgrade_enabled == true
        error_message = "DMS replication instance must have automatic minor version upgrade enabled. This ensures the instance receives minor engine upgrades automatically during maintenance windows, including bug fixes, security patches, and performance improvements. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/dms-controls.html#dms-6 for more details."
    }
}
