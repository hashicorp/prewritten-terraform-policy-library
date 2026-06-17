# Copyright IBM Corp. 2026

# RDS.7 - RDS clusters should have deletion protection enabled.

policy {}

input "rds-cluster-deletion-protection-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_rds_cluster" "deletion_protection_enabled" {
    enforcement_level = input.rds-cluster-deletion-protection-enabled-enforcement-level
    enforce {
        condition = core::try(attrs.deletion_protection, false)
        error_message = "RDS clusters should have deletion protection enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-7 for more details."
    }
}
