# Copyright IBM Corp. 2026

# Policy : DynamoDB.6 - DynamoDB tables should have deletion protection enabled

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.59.0, < 7.0.0"
    }
  }
}

input "dynamodb-table-deletion-protection-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_dynamodb_table" "deletion_protection_enabled" {
    enforcement_level = input.dynamodb-table-deletion-protection-enabled-enforcement-level
    locals {
        # Safe access to deletion_protection_enabled attribute with default false
        deletion_protection = core::try(attrs.deletion_protection_enabled, false)
    }

    enforce {
        condition     = local.deletion_protection == true
        error_message = "DynamoDB table must have deletion protection enabled. Set 'deletion_protection_enabled = true' to comply with NIST 800-53 REV5 controls (CA-9(1), CM-2, CM-2(2), CM-3, SC-5(2)). Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/dynamodb-controls.html#dynamodb-6 for more details."
    }
}
