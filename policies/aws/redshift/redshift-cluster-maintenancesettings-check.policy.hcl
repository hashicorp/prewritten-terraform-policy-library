# Copyright IBM Corp. 2026

# Redshift.6 - Amazon Redshift should have automatic upgrades to major versions enabled.

policy {}

input "redshift-cluster-maintenancesettings-check-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_redshift_cluster" "maintenance_settings_check" {
    enforcement_level = input.redshift-cluster-maintenancesettings-check-enforcement-level
    locals {
        version_upgrade = core::try(attrs.allow_version_upgrade, true)
        preferred_maintenance_window = core::try(attrs.preferred_maintenance_window, "")
        automated_snapshot_retention_period = core::try(attrs.automated_snapshot_retention_period, 1)
    }

    enforce {
        condition = local.version_upgrade == true && local.automated_snapshot_retention_period != 0
        error_message = "Redshift cluster does not have maintenance settings configured. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/redshift-controls.html#redshift-6 for more details."
    }
}