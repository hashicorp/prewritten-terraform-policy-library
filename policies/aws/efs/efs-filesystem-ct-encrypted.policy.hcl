# Copyright IBM Corp. 2026

# EFS.8 - EFS file systems should be encrypted at rest.

policy {}

input "efs-filesystem-ct-encrypted-enforcement-level" {
  type = string
  default = "advisory"
}

input "kms_key_arns" {
    type = string
    default = ""
}

resource_policy "aws_efs_file_system" "encryption_at_rest" {
    enforcement_level = input.efs-filesystem-ct-encrypted-enforcement-level
    locals {
        is_encrypted = core::try(attrs.encrypted, false)
        kms_key_id = core::try(attrs.kms_key_id, "")

        has_input = input.kms_key_arns != ""
        valid_key = local.has_input ? core::contains(core::split(",", input.kms_key_arns), local.kms_key_id) : true
    }

    enforce {
        condition = local.is_encrypted == true && local.valid_key
        error_message = "EFS file system does not have encryption at rest enabled. Set 'encrypted = true' in the resource configuration to comply with the policy. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/efs-controls.html#efs-8 for more details."
    }
}
