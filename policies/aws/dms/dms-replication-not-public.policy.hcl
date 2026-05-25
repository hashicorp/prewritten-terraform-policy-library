# Policy: DMS.1 - Database Migration Service replication instances should not be public

policy {}

resource_policy "aws_dms_replication_instance" "not_public" {
    locals {
        # Safe access to publicly_accessible attribute with default false
        # (AWS provider default is false when not specified)
        publicly_accessible = core::try(attrs.publicly_accessible, false)
    }

    enforce {
        condition = local.publicly_accessible == false
        error_message = "DMS replication instance must not be publicly accessible. The 'publicly_accessible' attribute is set to true, which exposes the instance to the public internet. Set 'publicly_accessible' to false or omit it (defaults to false) to ensure the instance has a private IP address. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/dms-controls.html#dms-1 for more details."
    }
}
