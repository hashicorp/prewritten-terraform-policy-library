# Copyright IBM Corp. 2026

# RDS.27 - RDS DB clusters should be encrypted at rest.

policy {}

resource_policy "aws_rds_cluster" "encrypted_at_rest" {
    locals {
        engine_mode = core::try(attrs.engine_mode, "provisioned")
        provisioned_condition = local.engine_mode == "provisioned" && core::try(attrs.storage_encrypted, false)
        serverless_condition = local.engine_mode == "serverless" && core::try(attrs.storage_encrypted, true)
    }

    enforce {
        condition = local.provisioned_condition || local.serverless_condition
        error_message = "RDS DB clusters should be encrypted at rest. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-27 for more details."
    }
}
