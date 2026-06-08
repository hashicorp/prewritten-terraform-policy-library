# Copyright IBM Corp. 2026

# DMS.13 - DMS replication instances should be configured to use multiple Availability Zones.

policy {}

resource_policy "aws_dms_replication_instance" "multi_az_enabled" {
    enforce {
        condition = core::try(attrs.multi_az, false) == true
        error_message = "DMS replication instance must have multi_az set to true to ensure high availability. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/dms-controls.html#dms-13 for more details."
    }
}
