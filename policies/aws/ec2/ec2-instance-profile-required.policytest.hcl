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
    subnet_id             = "subnet-0123456789abcdef0"
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
    subnet_id             = "subnet-0123456789abcdef0"
    tags = {
      Name = "fail-profile-empty"
    }
  }
}
