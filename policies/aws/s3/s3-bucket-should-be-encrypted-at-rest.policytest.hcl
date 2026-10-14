# Copyright IBM Corp. 2026

policytest {
  targets = ["s3-bucket-should-be-encrypted-at-rest.policy.hcl"]
}

# PASS: aws:kms algorithm with a customer-managed key
resource "aws_s3_bucket" "pass_kms_key" {
  attrs = {
    bucket = "pass_kms_key"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "pass_kms_key" {
  skip = true
  attrs = {
    bucket = "pass_kms_key"
    rule = [{
      apply_server_side_encryption_by_default = [{
        sse_algorithm     = "aws:kms"
        kms_master_key_id = "arn:aws:kms:us-east-1:123456789012:key/abcd"
      }]
    }]
  }
}

# PASS: aws:kms:dsse algorithm
resource "aws_s3_bucket" "pass_kms_dsse" {
  attrs = {
    bucket = "pass_kms_dsse"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "pass_kms_dsse" {
  skip = true
  attrs = {
    bucket = "pass_kms_dsse"
    rule = [{
      apply_server_side_encryption_by_default = [{
        sse_algorithm     = "aws:kms:dsse"
        kms_master_key_id = "arn:aws:kms:us-east-1:123456789012:key/abcd"
      }]
    }]
  }
}

# PASS: aws:kms with no explicit key uses the AWS-managed key
resource "aws_s3_bucket" "pass_kms_without_key" {
  attrs = {
    bucket = "pass_kms_without_key"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "pass_kms_without_key" {
  skip = true
  attrs = {
    bucket = "pass_kms_without_key"
    rule = [{
      apply_server_side_encryption_by_default = [{
        sse_algorithm = "aws:kms"
      }]
    }]
  }
}

# PASS: aws:kms with the AWS-managed S3 key
resource "aws_s3_bucket" "pass_aws_managed_key" {
  attrs = {
    bucket = "pass_aws_managed_key"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "pass_aws_managed_key" {
  skip = true
  attrs = {
    bucket = "pass_aws_managed_key"
    rule = [{
      apply_server_side_encryption_by_default = [{
        sse_algorithm     = "aws:kms"
        kms_master_key_id = "aws/s3"
      }]
    }]
  }
}

# FAIL: no encryption configuration (S3 default encryption is SSE-S3)
resource "aws_s3_bucket" "fail_no_config" {
  expect_failure = true
  attrs = {
    bucket = "fail_no_config"
  }
}

# FAIL: a KMS configuration for a different bucket does not apply
resource "aws_s3_bucket" "fail_config_for_other_bucket" {
  expect_failure = true
  attrs = {
    bucket = "fail_config_for_other_bucket"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "other_bucket_kms" {
  skip = true
  attrs = {
    bucket = "another_bucket"
    rule = [{
      apply_server_side_encryption_by_default = [{
        sse_algorithm = "aws:kms"
      }]
    }]
  }
}

# FAIL: AES256 is SSE-S3, not SSE-KMS
resource "aws_s3_bucket" "fail_aes256" {
  expect_failure = true
  attrs = {
    bucket = "fail_aes256"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "fail_aes256" {
  skip = true
  attrs = {
    bucket = "fail_aes256"
    rule = [{
      apply_server_side_encryption_by_default = [{
        sse_algorithm = "AES256"
      }]
    }]
  }
}

# FAIL: no default encryption rule
resource "aws_s3_bucket" "fail_no_rule" {
  expect_failure = true
  attrs = {
    bucket = "fail_no_rule"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "fail_no_rule" {
  skip = true
  attrs = {
    bucket = "fail_no_rule"
    rule   = []
  }
}

# FAIL: rule has no apply_server_side_encryption_by_default block
resource "aws_s3_bucket" "fail_no_apply_block" {
  expect_failure = true
  attrs = {
    bucket = "fail_no_apply_block"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "fail_no_apply_block" {
  skip = true
  attrs = {
    bucket = "fail_no_apply_block"
    rule = [{
      bucket_key_enabled = true
    }]
  }
}

# FAIL: empty algorithm
resource "aws_s3_bucket" "fail_empty_sse_algorithm" {
  expect_failure = true
  attrs = {
    bucket = "fail_empty_sse_algorithm"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "fail_empty_sse_algorithm" {
  skip = true
  attrs = {
    bucket = "fail_empty_sse_algorithm"
    rule = [{
      apply_server_side_encryption_by_default = [{
        sse_algorithm = ""
      }]
    }]
  }
}
