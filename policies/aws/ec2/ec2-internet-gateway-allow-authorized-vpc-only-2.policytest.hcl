# Copyright IBM Corp. 2026

# File 2: assumes inputs.authorized_vpc_ids = ["vpc-0abc123authorized",
# "vpc-0def456authorized"] (overridden via inputs {} block below). Exercises
# the "attached to an authorized VPC" (pass), "attached to an unauthorized
# VPC" (fail), and "vpc_id empty even though a list is configured" (fail)
# scenarios, which require a non-default, non-empty authorized_vpc_ids value.
policytest {
  targets = ["ec2-internet-gateway-allow-authorized-vpc-only.policy.hcl"]
}

inputs {
  ec2-internet-gateway-allow-authorized-vpc-only-authorized_vpc_ids = ["vpc-0abc123authorized", "vpc-0def456authorized"]
}

# PASS: aws_internet_gateway with vpc_id in the authorized list.
resource "aws_internet_gateway" "pass_igw_authorized_vpc" {
  attrs = {
    vpc_id = "vpc-0abc123authorized"
    tags = {
      Name = "igw-authorized"
    }
  }
}

# FAIL: aws_internet_gateway with vpc_id NOT in the authorized list.
resource "aws_internet_gateway" "fail_igw_unauthorized_vpc" {
  expect_failure = true
  attrs = {
    vpc_id = "vpc-0999999unauthorized"
    tags = {
      Name = "igw-unauthorized"
    }
  }
}

# FAIL: aws_internet_gateway with vpc_id explicitly set to an empty string,
# even though the authorized_vpc_ids list is configured — an empty/undefined
# attachment is never authorized regardless of the list.
resource "aws_internet_gateway" "fail_igw_empty_vpc_id" {
  expect_failure = true
  attrs = {
    vpc_id = ""
    tags = {
      Name = "igw-empty-vpc-id"
    }
  }
}

# PASS: aws_internet_gateway_attachment with vpc_id in the authorized list.
resource "aws_internet_gateway_attachment" "pass_attachment_authorized_vpc" {
  attrs = {
    internet_gateway_id = "igw-0abc123456789abcd"
    vpc_id               = "vpc-0def456authorized"
  }
}

# FAIL: aws_internet_gateway_attachment with vpc_id NOT in the authorized list.
resource "aws_internet_gateway_attachment" "fail_attachment_unauthorized_vpc" {
  expect_failure = true
  attrs = {
    internet_gateway_id = "igw-0abc123456789abcd"
    vpc_id               = "vpc-0999999unauthorized"
  }
}
