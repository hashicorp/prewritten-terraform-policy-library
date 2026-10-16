# Copyright IBM Corp. 2026

policytest {
  targets = ["ec2-instance-profile-required.policy.hcl"]
}

# Separate file: assumes inputs.allowed_iam_instance_profiles = ["approved-profile",
# "arn:aws:iam::123456789012:instance-profile/short-name"] (see Test File Rules case 1 —
# allow-list match scenarios need a non-empty input value, unlike the default-input
# scenarios in ec2-instance-profile-required.policytest.hcl).
inputs {
  ec2-instance-profile-required-allowed_iam_instance_profiles = ["approved-profile", "arn:aws:iam::123456789012:instance-profile/short-name"]
}

# PASS: profile exactly matches a plain-name entry in the allow-list.
resource "aws_instance" "pass_profile_in_allowlist_exact" {
  attrs = {
    ami                  = "ami-0123456789abcdef0"
    instance_type        = "t3.micro"
    iam_instance_profile = "approved-profile"
    subnet_id             = "subnet-0123456789abcdef0"
    tags = {
      Name = "pass-exact-match"
    }
  }
}

# PASS: profile equals the short name derived from an ARN-formatted allow-list entry.
resource "aws_instance" "pass_profile_matches_arn_derived_name" {
  attrs = {
    ami                  = "ami-0123456789abcdef0"
    instance_type        = "t3.micro"
    iam_instance_profile = "short-name"
    subnet_id             = "subnet-0123456789abcdef0"
    tags = {
      Name = "pass-arn-derived-match"
    }
  }
}

# FAIL: profile set but does not match any allow-list entry or derived short name.
resource "aws_instance" "fail_profile_not_in_allowlist" {
  expect_failure = true
  attrs = {
    ami                  = "ami-0123456789abcdef0"
    instance_type        = "t3.micro"
    iam_instance_profile = "unapproved-profile"
    subnet_id             = "subnet-0123456789abcdef0"
    tags = {
      Name = "fail-not-in-allowlist"
    }
  }
}

# FAIL: iam_instance_profile missing entirely even though an allow-list is configured —
# the presence check must fire regardless of allow-list state.
resource "aws_instance" "fail_profile_missing_with_allowlist" {
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
