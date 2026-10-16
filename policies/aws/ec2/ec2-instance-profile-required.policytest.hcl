# Copyright IBM Corp. 2026

policytest {
  targets = ["ec2-instance-profile-required.policy.hcl"]
}

# This file covers the "no allow-list configured" scenarios (default empty
# input.allowed_iam_instance_profiles = []). Allow-list match scenarios need a
# non-empty input value and live in ec2-instance-profile-required-2.policytest.hcl.

# PASS: profile set, no allow-list restrictions apply.
resource "aws_instance" "pass_profile_set_no_allowlist" {
  attrs = {
    ami                  = "ami-0123456789abcdef0"
    instance_type        = "t3.micro"
    iam_instance_profile = "any-instance-profile"
    subnet_id            = "subnet-0123456789abcdef0"
    tags = {
      Name = "pass-profile-set"
    }
  }
}

# FAIL: iam_instance_profile attribute is entirely missing (null).
resource "aws_instance" "fail_profile_missing" {
  expect_failure = true
  attrs = {
    ami           = "ami-0123456789abcdef0"
    instance_type = "t3.micro"
    subnet_id     = "subnet-0123456789abcdef0"
    tags = {
      Name = "fail-profile-missing"
    }
  }
}

# FAIL: iam_instance_profile attribute is set but empty.
resource "aws_instance" "fail_profile_empty" {
  expect_failure = true
  attrs = {
    ami                  = "ami-0123456789abcdef0"
    instance_type        = "t3.micro"
    iam_instance_profile = ""
    subnet_id            = "subnet-0123456789abcdef0"
    tags = {
      Name = "fail-profile-empty"
    }
  }
}

# ---- Cases merged from ec2-instance-profile-required-2.policytest.hcl ----

# PASS: profile exactly matches a plain-name entry in the allow-list.
resource "aws_instance" "pass_profile_in_allowlist_exact_f2" {
  attrs = {
    ami                  = "ami-0123456789abcdef0"
    instance_type        = "t3.micro"
    iam_instance_profile = "approved-profile"
    subnet_id            = "subnet-0123456789abcdef0"
    tags = {
      Name = "pass-exact-match"
    }
  }
}

# PASS: profile equals the short name derived from an ARN-formatted allow-list entry.
resource "aws_instance" "pass_profile_matches_arn_derived_name_f2" {
  attrs = {
    ami                  = "ami-0123456789abcdef0"
    instance_type        = "t3.micro"
    iam_instance_profile = "short-name"
    subnet_id            = "subnet-0123456789abcdef0"
    tags = {
      Name = "pass-arn-derived-match"
    }
  }
}


# FAIL: iam_instance_profile missing entirely even though an allow-list is configured —
# the presence check must fire regardless of allow-list state.
resource "aws_instance" "fail_profile_missing_with_allowlist_f2" {
  expect_failure = true
  attrs = {
    ami           = "ami-0123456789abcdef0"
    instance_type = "t3.micro"
    subnet_id     = "subnet-0123456789abcdef0"
    tags = {
      Name = "fail-missing-with-allowlist"
    }
  }
}
