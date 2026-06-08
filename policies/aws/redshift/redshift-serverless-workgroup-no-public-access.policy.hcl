# Copyright IBM Corp. 2026

# Policy: RedshiftServerless.3 - Redshift Serverless workgroups should prohibit public access

policy {}

resource_policy "aws_redshiftserverless_workgroup" "prohibit_public_access" {
    locals {
        # Safe access to publicly_accessible attribute with default false
        # If attribute is not set, it defaults to false (secure by default)
        publicly_accessible = core::try(attrs.publicly_accessible, false)
    }

    enforce {
        condition     = local.publicly_accessible == false
        error_message = "Redshift Serverless workgroup must not be publicly accessible. Set 'publicly_accessible = false' or omit the attribute (defaults to false). Public access allows connections from outside the VPC, which violates security best practices. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/redshiftserverless-controls.html#redshiftserverless-3 for more details."
    }
}
