# Copyright IBM Corp. 2026

policytest {
  targets = ["s3-bucket-should-be-encrypted-at-rest.policy.hcl"]
}

# pass_kms_key
resource "aws_s3_bucket" "pass_kms_key" {
  attrs = {
    id     = "pass_kms_key"
    bucket = "pass_kms_key"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "pass_kms_key_cfg" {
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

# pass_kms_dsse
resource "aws_s3_bucket" "pass_kms_dsse" {
  attrs = {
    id     = "pass_kms_dsse"
    bucket = "pass_kms_dsse"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "pass_kms_dsse_cfg" {
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

# pass_mixed_configs: one non-compliant (AES256) and one compliant (KMS) config
resource "aws_s3_bucket" "pass_mixed_configs" {
  attrs = {
    id     = "pass_mixed_configs"
    bucket = "pass_mixed_configs"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "pass_mixed_configs_cfg" {
  attrs = {
    bucket = "pass_mixed_configs"
    rule = [{
      apply_server_side_encryption_by_default = [{
        sse_algorithm = "AES256"
      }]
    }]
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "pass_mixed_configs1_cfg" {
  attrs = {
    bucket = "pass_mixed_configs"
    rule = [{
      apply_server_side_encryption_by_default = [{
        sse_algorithm     = "aws:kms"
        kms_master_key_id = "arn:aws:kms:us-east-1:123456789012:key/abcd"
      }]
    }]
  }
}

# fail_no_config
resource "aws_s3_bucket" "fail_no_config" {
  expect_failure = true
  attrs = {
    id     = "fail_no_config"
    bucket = "fail_no_config"
  }
}

# fail_config_for_other_bucket
resource "aws_s3_bucket" "fail_config_for_other_bucket" {
  expect_failure = true
  attrs = {
    id     = "fail_config_for_other_bucket"
    bucket = "fail_config_for_other_bucket"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "fail_config_for_other_bucket_cfg" {
  attrs = {
    bucket = "some_other_bucket"
    rule = [{
      apply_server_side_encryption_by_default = [{
        sse_algorithm     = "aws:kms"
        kms_master_key_id = "arn:aws:kms:us-east-1:123456789012:key/abcd"
      }]
    }]
  }
}

# fail_no_rule
resource "aws_s3_bucket" "fail_no_rule" {
  expect_failure = true
  attrs = {
    id     = "fail_no_rule"
    bucket = "fail_no_rule"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "fail_no_rule_cfg" {
  attrs = {
    bucket = "fail_no_rule"
    rule   = []
  }
}

# fail_no_apply_block
resource "aws_s3_bucket" "fail_no_apply_block" {
  expect_failure = true
  attrs = {
    id     = "fail_no_apply_block"
    bucket = "fail_no_apply_block"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "fail_no_apply_block_cfg" {
  attrs = {
    bucket = "fail_no_apply_block"
    rule = [{
      bucket_key_enabled = true
    }]
  }
}

# fail_aes256
resource "aws_s3_bucket" "fail_aes256" {
  expect_failure = true
  attrs = {
    id     = "fail_aes256"
    bucket = "fail_aes256"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "fail_aes256_cfg" {
  attrs = {
    bucket = "fail_aes256"
    rule = [{
      apply_server_side_encryption_by_default = [{
        sse_algorithm = "AES256"
      }]
    }]
  }
}

# fail_empty_sse_algorithm
resource "aws_s3_bucket" "fail_empty_sse_algorithm" {
  expect_failure = true
  attrs = {
    id     = "fail_empty_sse_algorithm"
    bucket = "fail_empty_sse_algorithm"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "fail_empty_sse_algorithm_cfg" {
  attrs = {
    bucket = "fail_empty_sse_algorithm"
    rule = [{
      apply_server_side_encryption_by_default = [{
        sse_algorithm     = ""
        kms_master_key_id = "arn:aws:kms:us-east-1:123456789012:key/abcd"
      }]
    }]
  }
}

# fail_kms_key_missing
resource "aws_s3_bucket" "fail_kms_key_missing" {
  expect_failure = true
  attrs = {
    id     = "fail_kms_key_missing"
    bucket = "fail_kms_key_missing"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "fail_kms_key_missing_cfg" {
  attrs = {
    bucket = "fail_kms_key_missing"
    rule = [{
      apply_server_side_encryption_by_default = [{
        sse_algorithm = "aws:kms"
      }]
    }]
  }
}

# fail_kms_key_null
resource "aws_s3_bucket" "fail_kms_key_null" {
  expect_failure = true
  attrs = {
    id     = "fail_kms_key_null"
    bucket = "fail_kms_key_null"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "fail_kms_key_null_cfg" {
  attrs = {
    bucket = "fail_kms_key_null"
    rule = [{
      apply_server_side_encryption_by_default = [{
        sse_algorithm     = "aws:kms"
        kms_master_key_id = null
      }]
    }]
  }
}

# fail_kms_key_empty
resource "aws_s3_bucket" "fail_kms_key_empty" {
  expect_failure = true
  attrs = {
    id     = "fail_kms_key_empty"
    bucket = "fail_kms_key_empty"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "fail_kms_key_empty_cfg" {
  attrs = {
    bucket = "fail_kms_key_empty"
    rule = [{
      apply_server_side_encryption_by_default = [{
        sse_algorithm     = "aws:kms"
        kms_master_key_id = ""
      }]
    }]
  }
}

# fail_kms_key_default_aws_s3
resource "aws_s3_bucket" "fail_kms_key_default_aws_s3" {
  expect_failure = true
  attrs = {
    id     = "fail_kms_key_default_aws_s3"
    bucket = "fail_kms_key_default_aws_s3"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "fail_kms_key_default_aws_s3_cfg" {
  attrs = {
    bucket = "fail_kms_key_default_aws_s3"
    rule = [{
      apply_server_side_encryption_by_default = [{
        sse_algorithm     = "aws:kms"
        kms_master_key_id = "aws/s3"
      }]
    }]
  }
}
