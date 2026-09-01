# Copyright IBM Corp. 2026

# S3 general purpose buckets should block public access

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "s3-bucket-level-public-access-prohibited-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_s3_bucket" "s3_block_public_access" {
  enforcement_level = input.s3-bucket-level-public-access-prohibited-enforcement-level

  connected "aws_s3_bucket_public_access_block" {
    connection {
      subject = "id"
      target  = "bucket"
    }

    cardinality = {
      min_matches = 1
    }

    enforce {
      condition     = core::try(self.block_public_acls, false) && core::try(self.block_public_policy, false) && core::try(self.ignore_public_acls, false) && core::try(self.restrict_public_buckets, false)
      error_message = "S3 bucket does not have all required public access block settings enabled. Set block_public_acls, block_public_policy, ignore_public_acls, and restrict_public_buckets all to 'true'"
    }
  }
}
