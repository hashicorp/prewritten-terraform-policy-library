# Copyright IBM Corp. 2026

# S3.8 - S3 general purpose buckets should block public access.

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "s3-bucket-level-public-access-prohibited-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_s3_bucket" "s3_block_public_access" {
  enforcement_level = input.s3-bucket-level-public-access-prohibited-enforcement-level
  connected "aws_s3_bucket_public_access_block" {
    min_instances = 1

    connection {
      subject   = "id"
      connected = "bucket"
    }

    filter = (
      core::try(connected.aws_s3_bucket_public_access_block.block_public_acls, false) &&
      core::try(connected.aws_s3_bucket_public_access_block.block_public_policy, false) &&
      core::try(connected.aws_s3_bucket_public_access_block.ignore_public_acls, false) &&
      core::try(connected.aws_s3_bucket_public_access_block.restrict_public_buckets, false)
    )
  }
}
