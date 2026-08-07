# Copyright IBM Corp. 2026

# S3 general purpose buckets should require requests to use SSL

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "s3-bucket-ssl-requests-only-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_s3_bucket" "ssl_required" {
  enforcement_level = input.s3-bucket-ssl-requests-only-enforcement-level

  connected "aws_s3_bucket_policy" {
    connection {
      subject = "bucket"
      target  = "bucket"
    }

    cardinality = {
      min_matches = 1
    }

    enforce {
      condition     = core::try(self.policy, "") != ""
      error_message = "S3 bucket must have an associated 'aws_s3_bucket_policy' with a non-empty 'policy' document that denies non-HTTPS requests"
    }

    enforce {
      condition = core::try(core::length([
        for stmt in core::try(core::jsondecode(self.policy).Statement, []) :
        stmt if (
          core::try(stmt.Effect, "") == "Deny" &&
          (core::try(stmt.Principal, "") == "*" || core::try(stmt.Principal.AWS, "") == "*") &&
          (core::try(stmt.Action, "") == "s3:*" || core::try(core::contains(stmt.Action, "s3:*"), false)) &&
          (core::try(stmt.Condition.Bool["aws:SecureTransport"], "") == "false" || core::try(stmt.Condition.Bool["aws:SecureTransport"], true) == false)
        )
      ]) > 0, false)
      error_message = "S3 bucket policy must include a statement that denies non-HTTPS requests (Effect=Deny, Principal=*, Action=s3:*, Condition aws:SecureTransport=false)"
    }
  }
}
