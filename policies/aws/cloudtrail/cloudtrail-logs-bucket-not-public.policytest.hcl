# Copyright IBM Corp. 2026

policytest {
  targets = ["cloudtrail-logs-bucket-not-public.policy.hcl"]
}

# PASS: All four S3 Block Public Access settings enabled — the strictest and
#       recommended configuration.  No ACL or bucket-policy resources needed.
resource "aws_s3_bucket_public_access_block" "all_four_enabled" {
  skip = true
  attrs = {
    bucket                  = "pab-all-four"
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
}

resource "aws_cloudtrail" "pass_all_public_access_block_settings" {
  attrs = {
    name           = "pass-all-public-access-block-settings"
    s3_bucket_name = "pab-all-four"
  }
}

# PASS: block_public_policy shields a bucket that also has a public-read
#       bucket policy.  The policy path is protected, and the ACL path is
#       protected by block_public_acls + ignore_public_acls.
resource "aws_s3_bucket_public_access_block" "pab_shields_public_policy" {
  skip = true
  attrs = {
    bucket                  = "pab-shields-public-policy"
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
}

resource "aws_s3_bucket_policy" "public_policy_but_blocked" {
  skip = true
  attrs = {
    bucket = "pab-shields-public-policy"
    policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":\"*\",\"Action\":\"s3:GetObject\",\"Resource\":\"arn:aws:s3:::pab-shields-public-policy/*\"}]}"
  }
}

resource "aws_cloudtrail" "pass_public_policy_shielded_by_pab" {
  attrs = {
    name           = "pass-public-policy-shielded-by-pab"
    s3_bucket_name = "pab-shields-public-policy"
  }
}

# PASS: block_public_acls + ignore_public_acls shield a bucket whose
#       standalone ACL uses the "public-read" canned value.
resource "aws_s3_bucket_public_access_block" "pab_shields_public_acl" {
  skip = true
  attrs = {
    bucket                  = "pab-shields-public-acl"
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
}

resource "aws_s3_bucket_acl" "public_acl_but_blocked" {
  skip = true
  attrs = {
    bucket = "pab-shields-public-acl"
    acl    = "public-read"
  }
}

resource "aws_cloudtrail" "pass_public_acl_shielded_by_pab" {
  attrs = {
    name           = "pass-public-acl-shielded-by-pab"
    s3_bucket_name = "pab-shields-public-acl"
  }
}

# FAIL: Private standalone aws_s3_bucket_acl but no PAB resource at all.
#       all_public_access_block_settings_enabled = false → bucket_is_private = false.
#       A private ACL alone is insufficient; all four PAB settings are required.
resource "aws_s3_bucket_acl" "private_standalone_acl" {
  skip = true
  attrs = {
    bucket = "acl-private"
    acl    = "private"
  }
}

resource "aws_cloudtrail" "fail_private_acl_no_pab" {
  expect_failure = true
  attrs = {
    name           = "fail-private-acl-no-pab"
    s3_bucket_name = "acl-private"
  }
}

# FAIL: Private inline ACL on aws_s3_bucket but no PAB resource at all.
#       all_public_access_block_settings_enabled = false → bucket_is_private = false.
resource "aws_s3_bucket" "private_inline_acl_bucket" {
  skip = true
  attrs = {
    bucket = "inline-private"
    acl    = "private"
  }
}

resource "aws_cloudtrail" "fail_private_inline_acl_no_pab" {
  expect_failure = true
  attrs = {
    name           = "fail-private-inline-acl-no-pab"
    s3_bucket_name = "inline-private"
  }
}

# PASS: bucket policy that grants access only to a specific AWS account
#       (not a wildcard principal) — not a public policy.
resource "aws_s3_bucket_public_access_block" "pab_non_public_policy" {
  skip = true
  attrs = {
    bucket                  = "non-public-policy-bucket"
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
}

resource "aws_s3_bucket_policy" "non_public_policy" {
  skip = true
  attrs = {
    bucket = "non-public-policy-bucket"
    policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"arn:aws:iam::123456789012:root\"},\"Action\":\"s3:GetObject\",\"Resource\":\"arn:aws:s3:::non-public-policy-bucket/*\"}]}"
  }
}

resource "aws_cloudtrail" "pass_non_public_bucket_policy" {
  attrs = {
    name           = "pass-non-public-bucket-policy"
    s3_bucket_name = "non-public-policy-bucket"
  }
}

# PASS: Filter — trails with an empty s3_bucket_name are excluded.
resource "aws_cloudtrail" "pass_empty_bucket_name" {
  attrs = {
    name           = "pass-empty-bucket-name"
    s3_bucket_name = ""
  }
}

# PASS: Filter — trails with a null s3_bucket_name are excluded.
resource "aws_cloudtrail" "pass_null_bucket_name" {
  attrs = {
    name           = "pass-null-bucket-name"
    s3_bucket_name = null
  }
}

# FAIL: One of the four PAB settings is missing (block_public_policy absent).
#       all_public_access_block_settings_enabled = false → fail.
resource "aws_s3_bucket_public_access_block" "pab_missing_block_public_policy" {
  skip = true
  attrs = {
    bucket                  = "pab-missing-block-public-policy"
    block_public_acls       = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
}

resource "aws_cloudtrail" "fail_missing_block_public_policy" {
  expect_failure = true
  attrs = {
    name           = "fail-missing-block-public-policy"
    s3_bucket_name = "pab-missing-block-public-policy"
  }
}

# FAIL: block_public_policy = false and the bucket policy grants public read
#       via a wildcard principal string ("*").
resource "aws_s3_bucket_public_access_block" "pab_no_block_policy" {
  skip = true
  attrs = {
    bucket                  = "bucket-public-policy"
    block_public_acls       = true
    block_public_policy     = false
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
}

resource "aws_s3_bucket_policy" "public_read_wildcard_principal" {
  skip = true
  attrs = {
    bucket = "bucket-public-policy"
    policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":\"*\",\"Action\":\"s3:GetObject\",\"Resource\":\"arn:aws:s3:::bucket-public-policy/*\"}]}"
  }
}

resource "aws_cloudtrail" "fail_public_bucket_policy_wildcard_principal" {
  expect_failure = true
  attrs = {
    name           = "fail-public-bucket-policy-wildcard-principal"
    s3_bucket_name = "bucket-public-policy"
  }
}

# FAIL: block_public_policy = false and the bucket policy grants public read
#       via Principal.AWS = "*".
resource "aws_s3_bucket_public_access_block" "pab_no_block_policy_aws_star" {
  skip = true
  attrs = {
    bucket                  = "bucket-policy-aws-star"
    block_public_acls       = true
    block_public_policy     = false
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
}

resource "aws_s3_bucket_policy" "public_read_aws_star_principal" {
  skip = true
  attrs = {
    bucket = "bucket-policy-aws-star"
    policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"*\"},\"Action\":\"s3:GetObject\",\"Resource\":\"arn:aws:s3:::bucket-policy-aws-star/*\"}]}"
  }
}

resource "aws_cloudtrail" "fail_public_bucket_policy_aws_star" {
  expect_failure = true
  attrs = {
    name           = "fail-public-bucket-policy-aws-star"
    s3_bucket_name = "bucket-policy-aws-star"
  }
}

# FAIL: Canned ACL "public-read" on standalone aws_s3_bucket_acl, and
#       block_public_acls / ignore_public_acls are both false.
resource "aws_s3_bucket_public_access_block" "pab_no_acl_blocking" {
  skip = true
  attrs = {
    bucket                  = "bucket-public-read-acl"
    block_public_acls       = false
    block_public_policy     = true
    ignore_public_acls      = false
    restrict_public_buckets = true
  }
}

resource "aws_s3_bucket_acl" "public_read_canned_acl" {
  skip = true
  attrs = {
    bucket = "bucket-public-read-acl"
    acl    = "public-read"
  }
}

resource "aws_cloudtrail" "fail_public_read_canned_acl" {
  expect_failure = true
  attrs = {
    name           = "fail-public-read-canned-acl"
    s3_bucket_name = "bucket-public-read-acl"
  }
}

# FAIL: Canned ACL "public-read-write" on standalone aws_s3_bucket_acl, and
#       block_public_acls / ignore_public_acls are both false.
resource "aws_s3_bucket_public_access_block" "pab_no_acl_blocking_rw" {
  skip = true
  attrs = {
    bucket                  = "bucket-public-read-write-acl"
    block_public_acls       = false
    block_public_policy     = true
    ignore_public_acls      = false
    restrict_public_buckets = true
  }
}

resource "aws_s3_bucket_acl" "public_read_write_canned_acl" {
  skip = true
  attrs = {
    bucket = "bucket-public-read-write-acl"
    acl    = "public-read-write"
  }
}

resource "aws_cloudtrail" "fail_public_read_write_canned_acl" {
  expect_failure = true
  attrs = {
    name           = "fail-public-read-write-canned-acl"
    s3_bucket_name = "bucket-public-read-write-acl"
  }
}

# FAIL: Granular ACL grant giving AllUsers the READ permission, with no PAB
#       settings to block public ACL access.
resource "aws_s3_bucket_public_access_block" "pab_no_acl_blocking_grant" {
  skip = true
  attrs = {
    bucket                  = "bucket-public-grant-acl"
    block_public_acls       = false
    block_public_policy     = true
    ignore_public_acls      = false
    restrict_public_buckets = true
  }
}

resource "aws_s3_bucket_acl" "public_grant_acl" {
  skip = true
  attrs = {
    bucket = "bucket-public-grant-acl"
    acl    = ""
    access_control_policy = [
      {
        grant = [
          {
            grantee   = [{ type = "Group", uri = "http://acs.amazonaws.com/groups/global/AllUsers" }]
            permission = "READ"
          }
        ]
        owner = [{ id = "owner-canonical-id" }]
      }
    ]
  }
}

resource "aws_cloudtrail" "fail_public_grant_acl" {
  expect_failure = true
  attrs = {
    name           = "fail-public-grant-acl"
    s3_bucket_name = "bucket-public-grant-acl"
  }
}

# FAIL: Inline "public-read" ACL on aws_s3_bucket with no PAB settings.
resource "aws_s3_bucket" "public_inline_acl_bucket" {
  skip = true
  attrs = {
    bucket = "bucket-inline-public"
    acl    = "public-read"
  }
}

resource "aws_cloudtrail" "fail_inline_public_acl" {
  expect_failure = true
  attrs = {
    name           = "fail-inline-public-acl"
    s3_bucket_name = "bucket-inline-public"
  }
}

# FAIL: No companion privacy resources at all — bucket_is_private = false.
resource "aws_cloudtrail" "fail_no_companion_resources" {
  expect_failure = true
  attrs = {
    name           = "fail-no-companion-resources"
    s3_bucket_name = "no-companion-resources"
  }
}
