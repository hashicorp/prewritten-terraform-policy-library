# Copyright IBM Corp. 2026

# Redshift.10 - Redshift clusters should be encrypted at rest. This control checks if Amazon Redshift clusters are encrypted at rest. The control fails if a Redshift cluster isn't encrypted at rest or if the encryption key is different from the provided key in the rule parameter.

policy {}

input "redshift-cluster-kms-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

input "kms_key_arns" {
    type = string
    default = ""
}

resource_policy "aws_redshift_cluster" "kms-enabled" {
    enforcement_level = input.redshift-cluster-kms-enabled-enforcement-level
    locals {
        has_encryption = core::try(attrs.encypted, true)
        kms_key_arn = local.has_encryption ? core::try(attrs.kms_key_id, "") : ""
        kms_key_arns_provided = input.kms_key_arns != ""
        valid_kms_key_arn = local.kms_key_arns_provided ? (local.kms_key_arn != "" ? core::contains(core::split(",", input.kms_key_arns), local.kms_key_arn) : true) : true
    }

    enforce {
        condition = local.has_encryption && local.valid_kms_key_arn
        error_message = "Redshift cluster either does not have encryption enabled or uses invalid KMS key. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/redshift-controls.html#redshift-10 for more details."
    }
}