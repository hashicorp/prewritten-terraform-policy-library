# Copyright IBM Corp. 2026

policytest {
  targets = [
    "cloudfront-s3-origin-non-existent-bucket.policy.hcl"
  ]
}

# Test 1: Pass - CloudFront distribution with S3 origin referencing existing bucket
resource "aws_s3_bucket" "existing_bucket" {
  attrs = {
    bucket = "my-existing-bucket"
  }
}

resource "aws_cloudfront_distribution" "pass_existing_bucket" {
  attrs = {
    origin = [
      {
        domain_name = "my-existing-bucket.s3.amazonaws.com"
        origin_id = "S3-my-existing-bucket"
        s3_origin_config = [
          {
            origin_access_identity = "origin-access-identity/cloudfront/ABCDEFG1234567"
          }
        ]
      }
    ]
    enabled = true
  }
}

# Test 2: Pass - unmanaged literal S3 origin cannot be verified from the plan
resource "aws_cloudfront_distribution" "fail_nonexistent_bucket_with_s3_config" {
  attrs = {
    origin = [
      {
        domain_name = "nonexistent-bucket.s3.amazonaws.com"
        origin_id = "S3-nonexistent-bucket"
        s3_origin_config = [
          {
            origin_access_identity = "origin-access-identity/cloudfront/ABCDEFG1234567"
          }
        ]
      }
    ]
    enabled = true
  }
}

# Test 3: Pass - unmanaged literal S3 domain cannot be verified from the plan
resource "aws_cloudfront_distribution" "fail_nonexistent_bucket_domain_pattern" {
  attrs = {
    origin = [
      {
        domain_name = "missing-bucket.s3.amazonaws.com"
        origin_id = "S3-missing-bucket"
        s3_origin_config = [
          {
            origin_access_identity = "origin-access-identity/cloudfront/ABCDEFG1234567"
          }
        ]
      }
    ]
    enabled = true
  }
}

# Test 4: Pass - CloudFront distribution with multiple S3 origins where all buckets exist
resource "aws_s3_bucket" "bucket_one" {
  attrs = {
    bucket = "bucket-one"
  }
}

resource "aws_s3_bucket" "bucket_two" {
  attrs = {
    bucket = "bucket-two"
  }
}

resource "aws_cloudfront_distribution" "pass_multiple_existing_buckets" {
  attrs = {
    origin = [
      {
        domain_name = "bucket-one.s3.amazonaws.com"
        origin_id = "S3-bucket-one"
        s3_origin_config = [
          {
            origin_access_identity = "origin-access-identity/cloudfront/ABCDEFG1234567"
          }
        ]
      },
      {
        domain_name = "bucket-two.s3.amazonaws.com"
        origin_id = "S3-bucket-two"
        s3_origin_config = [
          {
            origin_access_identity = "origin-access-identity/cloudfront/ABCDEFG1234567"
          }
        ]
      }
    ]
    enabled = true
  }
}

# Test 5: Pass - an unmanaged literal origin cannot be verified from the plan
resource "aws_s3_bucket" "bucket_exists" {
  attrs = {
    bucket = "bucket-exists"
  }
}

resource "aws_cloudfront_distribution" "fail_multiple_origins_one_missing" {
  attrs = {
    origin = [
      {
        domain_name = "bucket-exists.s3.amazonaws.com"
        origin_id = "S3-bucket-exists"
        s3_origin_config = [
          {
            origin_access_identity = "origin-access-identity/cloudfront/ABCDEFG1234567"
          }
        ]
      },
      {
        domain_name = "bucket-missing.s3.amazonaws.com"
        origin_id = "S3-bucket-missing"
        s3_origin_config = [
          {
            origin_access_identity = "origin-access-identity/cloudfront/ABCDEFG1234567"
          }
        ]
      }
    ]
    enabled = true
  }
}

# Test 6: Pass (filtered) - CloudFront distribution with only custom origins (no S3 origins)
resource "aws_cloudfront_distribution" "pass_custom_origin_only" {
  attrs = {
    origin = [
      {
        domain_name = "example.com"
        origin_id = "custom-origin"
        custom_origin_config = [
          {
            http_port = 80
            https_port = 443
            origin_protocol_policy = "https-only"
            origin_ssl_protocols = ["TLSv1.2"]
          }
        ]
      }
    ]
    enabled = true
  }
}

# Test 7: Pass - CloudFront distribution with regional S3 domain name that exists
resource "aws_s3_bucket" "regional_bucket" {
  attrs = {
    bucket = "my-regional-bucket"
  }
}

resource "aws_cloudfront_distribution" "pass_regional_s3_domain" {
  attrs = {
    origin = [
      {
        domain_name = "my-regional-bucket.s3.us-east-1.amazonaws.com"
        origin_id = "S3-my-regional-bucket"
        s3_origin_config = [
          {
            origin_access_identity = "origin-access-identity/cloudfront/ABCDEFG1234567"
          }
        ]
      }
    ]
    enabled = true
  }
}

# Test 8: Pass - an unmanaged literal regional S3 domain cannot be verified from the plan
resource "aws_cloudfront_distribution" "fail_regional_s3_domain_missing" {
  attrs = {
    origin = [
      {
        domain_name = "missing-regional-bucket.s3.eu-west-1.amazonaws.com"
        origin_id = "S3-missing-regional-bucket"
        s3_origin_config = [
          {
            origin_access_identity = "origin-access-identity/cloudfront/ABCDEFG1234567"
          }
        ]
      }
    ]
    enabled = true
  }
}

# Test 9: Pass - mixed managed and unmanaged literal S3 origins cannot prove non-existence
resource "aws_s3_bucket" "mixed_existing_bucket" {
  attrs = {
    bucket = "mixed-existing-bucket"
  }
}

resource "aws_cloudfront_distribution" "multi_origin_mixed" {
  attrs = {
    origin = [
      {
        domain_name              = "mixed-existing-bucket.s3.amazonaws.com"
        origin_id                = "S3-mixed-existing"
        origin_access_control_id = "E1234567890ABC"
      },
      {
        domain_name              = "mixed-nonexistent-bucket.s3.amazonaws.com"
        origin_id                = "S3-mixed-nonexistent"
        origin_access_control_id = "E0987654321XYZ"
      }
    ]
    enabled = true
  }
}

# Test 11: Pass - a non-S3 origin without custom_origin_config is out of scope
resource "aws_cloudfront_distribution" "pass_non_s3_origin_without_custom_config" {
  attrs = {
    origin = [
      {
        domain_name = "media.example.com"
        origin_id   = "external-media"
      }
    ]
    enabled = true
  }
}

# Test 12: Pass - an unmanaged literal S3 website bucket cannot be verified from the plan
resource "aws_cloudfront_distribution" "pass_unmanaged_s3_website_origin" {
  attrs = {
    origin = [
      {
        domain_name = "external-bucket.s3-website-us-east-1.amazonaws.com"
        origin_id   = "external-s3-website"
      }
    ]
    enabled = true
  }
}

# Test 10: Pass - Mixed OAC-style origins where all S3 buckets exist
resource "aws_s3_bucket" "mixed_bucket_a" {
  attrs = {
    bucket = "mixed-bucket-a"
  }
}

resource "aws_s3_bucket" "mixed_bucket_b" {
  attrs = {
    bucket = "mixed-bucket-b"
  }
}

resource "aws_cloudfront_distribution" "pass_multi_origin_mixed_all_exist" {
  attrs = {
    origin = [
      {
        domain_name              = "mixed-bucket-a.s3.amazonaws.com"
        origin_id                = "S3-mixed-a"
        origin_access_control_id = "E1234567890ABC"
      },
      {
        domain_name              = "mixed-bucket-b.s3.amazonaws.com"
        origin_id                = "S3-mixed-b"
        origin_access_control_id = "E0987654321XYZ"
      }
    ]
    enabled = true
  }
}
