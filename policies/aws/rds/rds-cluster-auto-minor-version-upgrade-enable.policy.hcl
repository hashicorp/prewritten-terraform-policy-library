# Copyright IBM Corp. 2026

# RDS.35 - RDS DB clusters should have automatic minor version upgrade enabled.

policy {}

resource_policy "aws_rds_cluster_instance" "auto_minor_version_upgrade_enabled" {
    enforce {
        condition = core::try(attrs.auto_minor_version_upgrade, true)
        error_message = "RDS cluster instance does not have automatic minor version upgrade enabled. Set 'auto_minor_version_upgrade = true' or remove the attribute to use the default (true) to ensure the instance receives security patches and bug fixes during maintenance windows. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-35 for more details."
    }
}
