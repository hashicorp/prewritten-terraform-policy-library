# Copyright IBM Corp. 2026

policytest {
    targets = [
        "s3-bucket-public-write-prohibited.policy.hcl"
    ]
}

# Test 1: Pass - All four blocking settings enabled
resource "aws_s3_bucket" "pass_all_block_settings" {
  attrs = {
    bucket = "pwp-t01-all-block"
  }
}

resource "aws_s3_bucket_public_access_block" "pass_all_block_settings" {
  skip = true
  attrs = {
    bucket                  = "pwp-t01-all-block"
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
}

# Test 2: Pass - block_public_acls + ignore_public_acls protect the ACL path;
#         block_public_policy protects the policy path; no ACL or bucket policy attached.
resource "aws_s3_bucket" "pass_block_acl_and_policy" {
  attrs = {
    bucket = "pwp-t02-acl-policy-block"
  }
}

resource "aws_s3_bucket_public_access_block" "pass_block_acl_and_policy" {
  skip = true
  attrs = {
    bucket                  = "pwp-t02-acl-policy-block"
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = false
  }
}

# Test 3: Pass - block_public_policy alone protects the policy path;
#         no ACL attached so ACL path is also clean.
resource "aws_s3_bucket" "pass_block_policy_only" {
  attrs = {
    bucket = "pwp-t03-policy-block-only"
  }
}

resource "aws_s3_bucket_public_access_block" "pass_block_policy_only" {
  skip = true
  attrs = {
    bucket                  = "pwp-t03-policy-block-only"
    block_public_acls       = false
    block_public_policy     = true
    ignore_public_acls      = false
    restrict_public_buckets = false
  }
}

# Test 4: Fail - All blocking settings disabled; bucket policy grants public s3:PutObject.
resource "aws_s3_bucket" "fail_all_block_disabled" {
  expect_failure = true
  attrs = {
    bucket = "pwp-t04-no-block"
  }
}

resource "aws_s3_bucket_public_access_block" "fail_all_block_disabled" {
  skip = true
  attrs = {
    bucket                  = "pwp-t04-no-block"
    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
  }
}

resource "aws_s3_bucket_policy" "fail_all_block_disabled" {
  skip = true
  attrs = {
    bucket = "pwp-t04-no-block"
    policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::pwp-t04-no-block/*"
    }
  ]
}
EOT
  }
}

# Test 5: Fail - block_public_acls + ignore_public_acls set but block_public_policy
#         is false and a public-write bucket policy exists.
resource "aws_s3_bucket" "fail_acl_block_no_policy_block" {
  expect_failure = true
  attrs = {
    bucket = "pwp-t05-acl-block-only"
  }
}

resource "aws_s3_bucket_public_access_block" "fail_acl_block_no_policy_block" {
  skip = true
  attrs = {
    bucket                  = "pwp-t05-acl-block-only"
    block_public_acls       = true
    block_public_policy     = false
    ignore_public_acls      = true
    restrict_public_buckets = false
  }
}

resource "aws_s3_bucket_policy" "fail_acl_block_no_policy_block" {
  skip = true
  attrs = {
    bucket = "pwp-t05-acl-block-only"
    policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::pwp-t05-acl-block-only/*"
    }
  ]
}
EOT
  }
}

# Test 6: Fail - No public access block settings at all; public-write policy attached.
resource "aws_s3_bucket" "fail_empty_block_with_public_policy" {
  expect_failure = true
  attrs = {
    bucket = "pwp-t06-empty-block"
  }
}

resource "aws_s3_bucket_public_access_block" "fail_empty_block_with_public_policy" {
  skip = true
  attrs = {
    bucket = "pwp-t06-empty-block"
  }
}

resource "aws_s3_bucket_policy" "fail_empty_block_with_public_policy" {
  skip = true
  attrs = {
    bucket = "pwp-t06-empty-block"
    policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::pwp-t06-empty-block/*"
    }
  ]
}
EOT
  }
}

# Test 7: Pass - Canned ACL set to 'private'
resource "aws_s3_bucket" "pass_acl_private" {
  attrs = {
    bucket = "pwp-t07-private-acl"
  }
}

resource "aws_s3_bucket_acl" "pass_acl_private" {
  skip = true
  attrs = {
    bucket = "pwp-t07-private-acl"
    acl    = "private"
  }
}

# Test 8: Pass - Canned ACL set to 'bucket-owner-full-control'
resource "aws_s3_bucket" "pass_acl_owner_full_control" {
  attrs = {
    bucket = "pwp-t08-owner-acl"
  }
}

resource "aws_s3_bucket_acl" "pass_acl_owner_full_control" {
  skip = true
  attrs = {
    bucket = "pwp-t08-owner-acl"
    acl    = "bucket-owner-full-control"
  }
}

# Test 9: Pass - Canned ACL set to 'public-read' (grants read, not write — not in public_write_acl_values)
resource "aws_s3_bucket" "pass_acl_public_read" {
  attrs = {
    bucket = "pwp-t09-pub-read-acl"
  }
}

resource "aws_s3_bucket_acl" "pass_acl_public_read" {
  skip = true
  attrs = {
    bucket = "pwp-t09-pub-read-acl"
    acl    = "public-read"
  }
}

# Test 10: Fail - Canned ACL set to 'public-read-write'
resource "aws_s3_bucket" "fail_acl_public_read_write" {
  expect_failure = true
  attrs = {
    bucket = "pwp-t10-pub-rw-acl"
  }
}

resource "aws_s3_bucket_acl" "fail_acl_public_read_write" {
  skip = true
  attrs = {
    bucket = "pwp-t10-pub-rw-acl"
    acl    = "public-read-write"
  }
}

# Test 11: Fail - access_control_policy granting WRITE to AllUsers group
resource "aws_s3_bucket" "fail_acp_write_all_users" {
  expect_failure = true
  attrs = {
    bucket = "pwp-t11-acp-write-all"
  }
}

resource "aws_s3_bucket_acl" "fail_acp_write_all_users" {
  skip = true
  attrs = {
    bucket = "pwp-t11-acp-write-all"
    access_control_policy = [
      {
        grant = [
          {
            grantee    = [{ type = "Group", uri = "http://acs.amazonaws.com/groups/global/AllUsers" }]
            permission = "WRITE"
          }
        ]
        owner = [{ id = "owner-canonical-id" }]
      }
    ]
  }
}

# Test 12: Fail - access_control_policy granting FULL_CONTROL to AllUsers group
resource "aws_s3_bucket" "fail_acp_full_control_all_users" {
  expect_failure = true
  attrs = {
    bucket = "pwp-t12-acp-fc-all"
  }
}

resource "aws_s3_bucket_acl" "fail_acp_full_control_all_users" {
  skip = true
  attrs = {
    bucket = "pwp-t12-acp-fc-all"
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

# Test 13: Pass - access_control_policy granting READ to AllUsers group (read is not write)
resource "aws_s3_bucket" "pass_acp_read_all_users" {
  attrs = {
    bucket = "pwp-t13-acp-read-all"
  }
}

resource "aws_s3_bucket_acl" "pass_acp_read_all_users" {
  skip = true
  attrs = {
    bucket = "pwp-t13-acp-read-all"
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

# Test 14: Pass - access_control_policy granting WRITE to a specific CanonicalUser (not public)
resource "aws_s3_bucket" "pass_acp_canonical_user" {
  attrs = {
    bucket = "pwp-t14-acp-canonical"
  }
}

resource "aws_s3_bucket_acl" "pass_acp_canonical_user" {
  skip = true
  attrs = {
    bucket = "pwp-t14-acp-canonical"
    access_control_policy = [
      {
        grant = [
          {
            grantee    = [{ type = "CanonicalUser", id = "specific-canonical-user-id" }]
            permission = "WRITE"
          }
        ]
        owner = [{ id = "owner-canonical-id" }]
      }
    ]
  }
}

# Test 15: Pass - Bucket policy allows s3:PutObject to a specific account ARN (not wildcard)
resource "aws_s3_bucket" "pass_policy_specific_principal" {
  attrs = {
    bucket = "pwp-t15-pol-specific"
  }
}

resource "aws_s3_bucket_policy" "pass_policy_specific_principal" {
  skip = true
  attrs = {
    bucket = "pwp-t15-pol-specific"
    policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "AWS": "arn:aws:iam::123456789012:root" },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::pwp-t15-pol-specific/*"
    }
  ]
}
EOT
  }
}

# Test 16: Pass - Bucket policy allows only s3:GetObject to wildcard principal (read, not write)
resource "aws_s3_bucket" "pass_policy_get_only_public" {
  attrs = {
    bucket = "pwp-t16-pol-get-pub"
  }
}

resource "aws_s3_bucket_policy" "pass_policy_get_only_public" {
  skip = true
  attrs = {
    bucket = "pwp-t16-pol-get-pub"
    policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::pwp-t16-pol-get-pub/*"
    }
  ]
}
EOT
  }
}

# Test 17: Fail - Bucket policy grants s3:PutObject to wildcard (*) principal
resource "aws_s3_bucket" "fail_policy_put_object_wildcard" {
  expect_failure = true
  attrs = {
    bucket = "pwp-t17-pol-put-pub"
  }
}

resource "aws_s3_bucket_policy" "fail_policy_put_object_wildcard" {
  skip = true
  attrs = {
    bucket = "pwp-t17-pol-put-pub"
    policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::pwp-t17-pol-put-pub/*"
    }
  ]
}
EOT
  }
}

# Test 18: Fail - Bucket policy grants s3:PutObject to wildcard AWS principal
resource "aws_s3_bucket" "fail_policy_put_object_aws_wildcard" {
  expect_failure = true
  attrs = {
    bucket = "pwp-t18-pol-put-awspub"
  }
}

resource "aws_s3_bucket_policy" "fail_policy_put_object_aws_wildcard" {
  skip = true
  attrs = {
    bucket = "pwp-t18-pol-put-awspub"
    policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "AWS": "*" },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::pwp-t18-pol-put-awspub/*"
    }
  ]
}
EOT
  }
}

# Test 19: Fail - Bucket policy grants s3:Put* (wildcard action) to public
resource "aws_s3_bucket" "fail_policy_put_star_action" {
  expect_failure = true
  attrs = {
    bucket = "pwp-t19-pol-putstar-pub"
  }
}

resource "aws_s3_bucket_policy" "fail_policy_put_star_action" {
  skip = true
  attrs = {
    bucket = "pwp-t19-pol-putstar-pub"
    policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:Put*",
      "Resource": "arn:aws:s3:::pwp-t19-pol-putstar-pub/*"
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
    bucket = "pwp-t20-pol-s3star-pub"
  }
}

resource "aws_s3_bucket_policy" "fail_policy_s3_star_action" {
  skip = true
  attrs = {
    bucket = "pwp-t20-pol-s3star-pub"
    policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::pwp-t20-pol-s3star-pub/*"
    }
  ]
}
EOT
  }
}

# Test 21: Pass - Public-write bucket policy present but block_public_policy = true overrides it
resource "aws_s3_bucket" "pass_block_policy_overrides_public_policy" {
  attrs = {
    bucket = "pwp-t21-block-overrides"
  }
}

resource "aws_s3_bucket_policy" "pass_block_policy_overrides_public_policy" {
  skip = true
  attrs = {
    bucket = "pwp-t21-block-overrides"
    policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::pwp-t21-block-overrides/*"
    }
  ]
}
EOT
  }
}

resource "aws_s3_bucket_public_access_block" "pass_block_policy_overrides_public_policy" {
  skip = true
  attrs = {
    bucket                  = "pwp-t21-block-overrides"
    block_public_policy     = true
    block_public_acls       = false
    ignore_public_acls      = false
    restrict_public_buckets = false
  }
}

# Test 22: Pass - public-read-write ACL present but block_public_acls + ignore_public_acls override it
resource "aws_s3_bucket" "pass_block_acls_overrides_public_acl" {
  attrs = {
    bucket = "pwp-t22-acl-overrides"
  }
}

resource "aws_s3_bucket_acl" "pass_block_acls_overrides_public_acl" {
  skip = true
  attrs = {
    bucket = "pwp-t22-acl-overrides"
    acl    = "public-read-write"
  }
}

resource "aws_s3_bucket_public_access_block" "pass_block_acls_overrides_public_acl" {
  skip = true
  attrs = {
    bucket                  = "pwp-t22-acl-overrides"
    block_public_acls       = true
    ignore_public_acls      = true
    block_public_policy     = false
    restrict_public_buckets = false
  }
}

# Test 23: Pass - Bare bucket with no ACL, no bucket policy, no public access block
#         (no public write configured => both paths protected by default)
resource "aws_s3_bucket" "pass_bare_bucket" {
  attrs = {
    bucket = "pwp-t23-bare-bucket"
  }
}
