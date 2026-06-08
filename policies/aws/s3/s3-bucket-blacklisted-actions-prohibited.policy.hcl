# Copyright IBM Corp. 2026

# S3.6 - S3 Bucket Policies Should Restrict Access to Other AWS Accounts. This control checks whether an Amazon S3 general purpose bucket policy prevents principals from other AWS accounts from performing denied actions on resources in the S3 bucket.
# 
# NOTE: This policy uses exact string matching for blocked actions. Wildcard patterns (e.g., s3:GetBucket*) are NOT supported.
# Users must explicitly list all blocked actions in the CSV format.
# Example: "s3:DeleteBucketPolicy,s3:PutBucketAcl,s3:PutBucketPolicy,s3:PutEncryptionConfiguration,s3:PutObjectAcl"

policy {}

input "blacklisted_action_pattern" {
    type = string
    default = "s3:DeleteBucketPolicy,s3:PutBucketAcl,s3:PutBucketPolicy,s3:PutEncryptionConfiguration,s3:PutObjectAcl"
}

resource_policy "aws_s3_bucket_policy" "s3-bucket-blacklisted-actions-prohibited" {
    locals {
        policy_doc = core::jsondecode(attrs.policy)
        blacklisted_actions = core::split(",", input.blacklisted_action_pattern)

        violating_statements = [for statement in core::try(local.policy_doc.Statement, []) : statement
            if core::try(statement.Effect, "") == "Allow" &&
            (core::contains([
            core::try(statement.Principal == "*", false),
            core::try(statement.Principal.AWS == "*", false),
            core::try(core::length(core::try(statement.Principal.AWS, [])) > 0 && core::contains(statement.Principal.AWS, "*"), false),
            core::try(core::length(core::regexall("^arn:aws:iam::[0-9]{12}:", core::try(statement.Principal.AWS, ""))) > 0, false),
            core::try(core::length([for p in core::try(statement.Principal.AWS, []) : p if core::length(core::regexall("^arn:aws:iam::[0-9]{12}:", p)) > 0]) > 0, false)
            ], true)) &&
            (core::contains([
            core::try(core::contains(local.blacklisted_actions, core::try(statement.Action, "")), false),
            core::try(core::length([for action in core::try(statement.Action, []) : action if core::contains(local.blacklisted_actions, action)]) > 0, false)
            ], true))
        ]
        
        has_violation = core::length(local.violating_statements) > 0
    }

    enforce {
        condition = !local.has_violation
        error_message = "S3 bucket policy allows blacklisted actions for cross-account or wildcard principals. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-6 for more details."
    }
}