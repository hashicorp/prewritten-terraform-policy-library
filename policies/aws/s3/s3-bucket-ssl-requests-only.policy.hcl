# Copyright IBM Corp. 2026

# Policy: S3.5 - S3 general purpose buckets should require requests to use SSL

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "s3-bucket-ssl-requests-only-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_s3_bucket" "ssl_required" {
  enforcement_level = input.s3-bucket-ssl-requests-only-enforcement-level
  connected "aws_s3_bucket_policy" {
    min_instances = 1

    connection {
      subject   = "bucket"
      connected = "bucket"
    }

    # Statement may be either a list or a single object.
    filter = core::try(connected.aws_s3_bucket_policy.policy, "") != "" && core::length([
      for stmt in core::concat(
        core::try([
          for statement in core::jsondecode(connected.aws_s3_bucket_policy.policy).Statement :
          statement if core::try(statement.Effect, "") != ""
        ], []),
        core::try(core::jsondecode(connected.aws_s3_bucket_policy.policy).Statement.Effect, "") != "" ?
        core::try([core::jsondecode(connected.aws_s3_bucket_policy.policy).Statement], []) : []
      ) : stmt if (
        core::try(stmt.Effect, "") == "Deny" &&
        (
          core::try(stmt.Principal, "") == "*" ||
          core::try(stmt.Principal.AWS, "") == "*" ||
          core::try(stmt.Principal.AWS[0], "") == "*"
        ) &&
        (
          core::try(stmt.Action, "") == "s3:*" ||
          core::try(core::contains(stmt.Action, "s3:*"), false)
        ) &&
        (
          core::try(stmt.Condition.Bool["aws:SecureTransport"], "") == "false" ||
          core::try(stmt.Condition.Bool["aws:SecureTransport"], true) == false
        )
      )
    ]) > 0
  }
}
