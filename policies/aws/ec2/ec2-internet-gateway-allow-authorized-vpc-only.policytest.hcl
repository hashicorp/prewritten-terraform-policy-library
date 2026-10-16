# Copyright IBM Corp. 2026

# File 1: assumes default input values (authorized_vpc_ids = [] — no inputs {}
# override). Exercises the "vpc_id missing is skipped" and "no authorized VPCs
# configured means every attachment is unauthorized" scenarios.
policytest {
  targets = ["ec2-internet-gateway-allow-authorized-vpc-only.policy.hcl"]
}

# PASS: aws_internet_gateway with no vpc_id attribute at all is skipped by the
# policy's filter (it will be attached via a separate aws_internet_gateway_attachment).
resource "aws_internet_gateway" "pass_igw_no_vpc_id" {
  attrs = {
    tags = {
      Name = "igw-no-vpc-id"
    }
  }
}

# FAIL: aws_internet_gateway with vpc_id set, but authorized_vpc_ids defaults to
# an empty list, so no VPC can be considered authorized.
resource "aws_internet_gateway" "fail_igw_no_authorized_list" {
  expect_failure = true
  attrs = {
    vpc_id = "vpc-0123456789abcdef0"
    tags = {
      Name = "igw-unauthorized-no-list"
    }
  }
}

# FAIL: aws_internet_gateway_attachment with vpc_id set, but authorized_vpc_ids
# defaults to an empty list, so no VPC can be considered authorized.
resource "aws_internet_gateway_attachment" "fail_attachment_no_authorized_list" {
  expect_failure = true
  attrs = {
    internet_gateway_id = "igw-0123456789abcdef0"
    vpc_id               = "vpc-0123456789abcdef0"
  }
}

# FAIL: aws_internet_gateway with vpc_id omitted entirely from attrs is covered
# by the pass_igw_no_vpc_id case above (missing-attribute scenario = skip/pass
# by design, since this policy intentionally skips IGWs without vpc_id).
