# Copyright IBM Corp. 2026

policytest {
    targets = [
        "s3-bucket-public-read-prohibited.policy.hcl"
    ]
}

# Test 1: Pass - All four blocking settings enabled
resource "aws_s3_bucket" "pass_all_block_settings" {
  attrs = {
    bucket = "prp-t01-all-block"
  }
}

resource "aws_s3_bucket_public_access_block" "pass_all_block_settings" {
  skip = true
  attrs = {
    bucket                  = "prp-t01-all-block"
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
}

# Test 2: Pass - block_public_policy alone protects the policy path;
#         no ACL or bucket policy attached so both paths are clean.
resource "aws_s3_bucket" "pass_block_policy_only" {
  attrs = {
    bucket = "prp-t02-policy-block-only"
  }
}

resource "aws_s3_bucket_public_access_block" "pass_block_policy_only" {
  skip = true
  attrs = {
    bucket                  = "prp-t02-policy-block-only"
    block_public_acls       = false
    block_public_policy     = true
    ignore_public_acls      = false
    restrict_public_buckets = false
  }
}

# Test 3: Fail - All blocking settings disabled; bucket policy grants public read.
resource "aws_s3_bucket" "fail_all_block_disabled" {
  expect_failure = true
  attrs = {
    bucket = "prp-t03-no-block"
  }
}

resource "aws_s3_bucket_public_access_block" "fail_all_block_disabled" {
  skip = true
  attrs = {
    bucket                  = "prp-t03-no-block"
    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
  }
}

resource "aws_s3_bucket_policy" "fail_all_block_disabled" {
  skip = true
  attrs = {
    bucket = "prp-t03-no-block"
    policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::prp-t03-no-block/*"
    }
  ]
}
EOT
  }
}

# Test 4: Fail - block_public_acls + ignore_public_acls set but block_public_policy
#         is false and a public-read bucket policy exists.
resource "aws_s3_bucket" "fail_acl_block_no_policy_block" {
  expect_failure = true
  attrs = {
    bucket = "prp-t04-acl-block-only"
  }
}

resource "aws_s3_bucket_public_access_block" "fail_acl_block_no_policy_block" {
  skip = true
  attrs = {
    bucket                  = "prp-t04-acl-block-only"
    block_public_acls       = true
    block_public_policy     = false
    ignore_public_acls      = true
    restrict_public_buckets = false
  }
}

resource "aws_s3_bucket_policy" "fail_acl_block_no_policy_block" {
  skip = true
  attrs = {
    bucket = "prp-t04-acl-block-only"
    policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::prp-t04-acl-block-only/*"
    }
  ]
}
EOT
  }
}

# Test 5: Fail - No public access block settings at all; public-read policy attached.
resource "aws_s3_bucket" "fail_empty_block_with_public_policy" {
  expect_failure = true
  attrs = {
    bucket = "prp-t05-empty-block"
  }
}

resource "aws_s3_bucket_public_access_block" "fail_empty_block_with_public_policy" {
  skip = true
  attrs = {
    bucket = "prp-t05-empty-block"
  }
}

resource "aws_s3_bucket_policy" "fail_empty_block_with_public_policy" {
  skip = true
  attrs = {
    bucket = "prp-t05-empty-block"
    policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::prp-t05-empty-block/*"
    }
  ]
}
EOT
  }
}

# Test 6: Pass - Canned ACL set to 'private'
resource "aws_s3_bucket" "pass_acl_private" {
  attrs = {
    bucket = "prp-t06-private-acl"
  }
}

resource "aws_s3_bucket_acl" "pass_acl_private" {
  skip = true
  attrs = {
    bucket = "prp-t06-private-acl"
    acl    = "private"
  }
}

# Test 7: Pass - Canned ACL set to 'bucket-owner-full-control'
resource "aws_s3_bucket" "pass_acl_owner_full_control" {
  attrs = {
    bucket = "prp-t07-owner-acl"
  }
}

resource "aws_s3_bucket_acl" "pass_acl_owner_full_control" {
  skip = true
  attrs = {
    bucket = "prp-t07-owner-acl"
    acl    = "bucket-owner-full-control"
  }
}

# Test 8: Pass - Canned ACL set to 'aws-exec-read' (not in public_acl_values list)
resource "aws_s3_bucket" "pass_acl_exec_read" {
  attrs = {
    bucket = "prp-t08-exec-read-acl"
  }
}

resource "aws_s3_bucket_acl" "pass_acl_exec_read" {
  skip = true
  attrs = {
    bucket = "prp-t08-exec-read-acl"
    acl    = "aws-exec-read"
  }
}

# Test 9: Fail - Canned ACL set to 'public-read'
resource "aws_s3_bucket" "fail_acl_public_read" {
  expect_failure = true
  attrs = {
    bucket = "prp-t09-pub-read-acl"
  }
}

resource "aws_s3_bucket_acl" "fail_acl_public_read" {
  skip = true
  attrs = {
    bucket = "prp-t09-pub-read-acl"
    acl    = "public-read"
  }
}

# Test 10: Fail - Canned ACL set to 'public-read-write'
resource "aws_s3_bucket" "fail_acl_public_read_write" {
  expect_failure = true
  attrs = {
    bucket = "prp-t10-pub-rw-acl"
  }
}

resource "aws_s3_bucket_acl" "fail_acl_public_read_write" {
  skip = true
  attrs = {
    bucket = "prp-t10-pub-rw-acl"
    acl    = "public-read-write"
  }
}

# Test 11: Fail - access_control_policy granting READ to AllUsers group
resource "aws_s3_bucket" "fail_acp_read_all_users" {
  expect_failure = true
  attrs = {
    bucket = "prp-t11-acp-read-all"
  }
}

resource "aws_s3_bucket_acl" "fail_acp_read_all_users" {
  skip = true
  attrs = {
    bucket = "prp-t11-acp-read-all"
    access_control_policy = [
      {
        grant = [
          {
            grantee    = [{ type = "Group", uri = "http://acs.amazonaws.com/groups/global/AllUsers" }]
            permission = "READ"
          }
        ]
        owner = [{ id = "owner-canonical-id" }]
      }
    ]
  }
}

# Test 12: Fail - access_control_policy granting READ_ACP to AllUsers group
resource "aws_s3_bucket" "fail_acp_read_acp_all_users" {
  expect_failure = true
  attrs = {
    bucket = "prp-t12-acp-readacp-all"
  }
}

resource "aws_s3_bucket_acl" "fail_acp_read_acp_all_users" {
  skip = true
  attrs = {
    bucket = "prp-t12-acp-readacp-all"
    access_control_policy = [
      {
        grant = [
          {
            grantee    = [{ type = "Group", uri = "http://acs.amazonaws.com/groups/global/AllUsers" }]
            permission = "READ_ACP"
          }
        ]
        owner = [{ id = "owner-canonical-id" }]
      }
    ]
  }
}

# Test 13: Fail - access_control_policy granting FULL_CONTROL to AllUsers group
resource "aws_s3_bucket" "fail_acp_full_control_all_users" {
  expect_failure = true
  attrs = {
    bucket = "prp-t13-acp-fc-all"
  }
}

resource "aws_s3_bucket_acl" "fail_acp_full_control_all_users" {
  skip = true
  attrs = {
    bucket = "prp-t13-acp-fc-all"
    access_control_policy = [
      {
        grant = [
          {
            grantee    = [{ type = "Group", uri = "http://acs.amazonaws.com/groups/global/AllUsers" }]
            permission = "FULL_CONTROL"
          }
        ]
        owner = [{ id = "owner-canonical-id" }]
      }
    ]
  }
}

# Test 14: Pass - access_control_policy granting READ to a specific CanonicalUser (not public)
resource "aws_s3_bucket" "pass_acp_canonical_user" {
  attrs = {
    bucket = "prp-t14-acp-canonical"
  }
}

resource "aws_s3_bucket_acl" "pass_acp_canonical_user" {
  skip = true
  attrs = {
    bucket = "prp-t14-acp-canonical"
    access_control_policy = [
      {
        grant = [
          {
            grantee    = [{ type = "CanonicalUser", id = "specific-canonical-user-id" }]
            permission = "READ"
          }
        ]
        owner = [{ id = "owner-canonical-id" }]
      }
    ]
  }
}

# Test 15: Pass - Bucket policy allows read to a specific account ARN (not wildcard)
resource "aws_s3_bucket" "pass_policy_specific_principal" {
  attrs = {
    bucket = "prp-t15-pol-specific"
  }
}

resource "aws_s3_bucket_policy" "pass_policy_specific_principal" {
  skip = true
  attrs = {
    bucket = "prp-t15-pol-specific"
    policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "AWS": "arn:aws:iam::123456789012:root" },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::prp-t15-pol-specific/*"
    }
  ]
}
EOT
  }
}

# Test 16: Pass - Bucket policy allows only s3:PutObject to wildcard principal (no read action)
resource "aws_s3_bucket" "pass_policy_write_only_public" {
  attrs = {
    bucket = "prp-t16-pol-write-pub"
  }
}

resource "aws_s3_bucket_policy" "pass_policy_write_only_public" {
  skip = true
  attrs = {
    bucket = "prp-t16-pol-write-pub"
    policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::prp-t16-pol-write-pub/*"
    }
  ]
}
EOT
  }
}

# Test 17: Fail - Bucket policy grants s3:GetObject to wildcard (*) principal
resource "aws_s3_bucket" "fail_policy_get_object_wildcard" {
  expect_failure = true
  attrs = {
    bucket = "prp-t17-pol-get-pub"
  }
}

resource "aws_s3_bucket_policy" "fail_policy_get_object_wildcard" {
  skip = true
  attrs = {
    bucket = "prp-t17-pol-get-pub"
    policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::prp-t17-pol-get-pub/*"
    }
  ]
}
EOT
  }
}

# Test 18: Fail - Bucket policy grants s3:GetObjectVersion to wildcard AWS principal
resource "aws_s3_bucket" "fail_policy_get_object_version_wildcard" {
  expect_failure = true
  attrs = {
    bucket = "prp-t18-pol-getver-pub"
  }
}

resource "aws_s3_bucket_policy" "fail_policy_get_object_version_wildcard" {
  skip = true
  attrs = {
    bucket = "prp-t18-pol-getver-pub"
    policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "AWS": "*" },
      "Action": "s3:GetObjectVersion",
      "Resource": "arn:aws:s3:::prp-t18-pol-getver-pub/*"
    }
  ]
}
EOT
  }
}

# Test 19: Fail - Bucket policy grants s3:Get* (wildcard action) to public
resource "aws_s3_bucket" "fail_policy_get_star_action" {
  expect_failure = true
  attrs = {
    bucket = "prp-t19-pol-getstar-pub"
  }
}

resource "aws_s3_bucket_policy" "fail_policy_get_star_action" {
  skip = true
  attrs = {
    bucket = "prp-t19-pol-getstar-pub"
    policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:Get*",
      "Resource": "arn:aws:s3:::prp-t19-pol-getstar-pub/*"
    }
  ]
}
EOT
  }
}

# Test 20: Fail - Bucket policy grants s3:* (full wildcard action) to public
resource "aws_s3_bucket" "fail_policy_s3_star_action" {
  expect_failure = true
  attrs = {
    bucket = "prp-t20-pol-s3star-pub"
  }
}

resource "aws_s3_bucket_policy" "fail_policy_s3_star_action" {
  skip = true
  attrs = {
    bucket = "prp-t20-pol-s3star-pub"
    policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::prp-t20-pol-s3star-pub/*"
    }
  ]
}
EOT
  }
}

# Test 21: Pass - Public-read bucket policy present but block_public_policy = true overrides it
resource "aws_s3_bucket" "pass_block_policy_overrides_public_policy" {
  attrs = {
    bucket = "prp-t21-block-overrides"
  }
}

resource "aws_s3_bucket_policy" "pass_block_policy_overrides_public_policy" {
  skip = true
  attrs = {
    bucket = "prp-t21-block-overrides"
    policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::prp-t21-block-overrides/*"
    }
  ]
}
EOT
  }
}

resource "aws_s3_bucket_public_access_block" "pass_block_policy_overrides_public_policy" {
  skip = true
  attrs = {
    bucket              = "prp-t21-block-overrides"
    block_public_policy = true
    block_public_acls   = false
    ignore_public_acls  = false
    restrict_public_buckets = false
  }
}

# Test 22: Pass - Bare bucket with no ACL, no bucket policy, no public access block
#         (no public access configured => both paths protected by default)
resource "aws_s3_bucket" "pass_bare_bucket" {
  attrs = {
    bucket = "prp-t22-bare-bucket"
  }
}
