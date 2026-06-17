# Copyright IBM Corp. 2026

# DocumentDB.1 - DocumentDB clusters should be encrypted at rest. This control checks if Amazon DocumentDB clusters are encrypted at rest. The control fails if a DocumentDB cluster isn't encrypted at rest or if the encryption key is different from the provided key in the rule parameter.

policy {}

input "docdb-cluster-encrypted-enforcement-level" {
  type = string
  default = "advisory"
}

input "kms_key_arns" {
    type = string
    default = ""
}

resource_policy "aws_docdb_cluster" "encrypted-at-rest" {
    enforcement_level = input.docdb-cluster-encrypted-enforcement-level
    locals {
        has_encryption = core::try(attrs.storage_encrypted, false)
        kms_key_arn = local.has_encryption ? core::try(attrs.kms_key_id, "") : ""
        kms_key_arns_provided = input.kms_key_arns != ""
        valid_kms_key_arn = local.kms_key_arns_provided ? (local.kms_key_arn != "" ? core::contains(core::split(",", input.kms_key_arns), local.kms_key_arn) : true) : true
    }

    enforce {
        condition = local.has_encryption && local.valid_kms_key_arn
        error_message = "DocumentDB cluster either does not have encryption enabled or uses invalid KMS key. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/documentdb-controls.html#documentdb-1 for more details."
    }
}