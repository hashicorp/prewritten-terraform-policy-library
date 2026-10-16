# Copyright IBM Corp. 2026

# ec2-belong-to-vpc-2.policytest.hcl
# Separate file: assumes inputs.vpc_id = "vpc-aaaa1111" (see 4.2 case 1 — these
# scenarios require a non-default `inputs {}` value and cannot share a file
# with the default-input scenarios in ec2-belong-to-vpc.policytest.hcl).
# Exercises the subnet_id -> aws_subnet VPC-matching cross-resource lookup.

policytest {
  targets = ["ec2-belong-to-vpc.policy.hcl"]
}

inputs {
  ec2-belong-to-vpc-vpc_id = "vpc-aaaa1111"
}

# Subnet that belongs to the required VPC
resource "aws_subnet" "matching_vpc" {
  skip = true
  attrs = {
    id         = "subnet-aaaa0001"
    vpc_id     = "vpc-aaaa1111"
    cidr_block = "10.0.1.0/24"
  }
}

# Subnet that belongs to a DIFFERENT VPC
resource "aws_subnet" "mismatched_vpc" {
  skip = true
  attrs = {
    id         = "subnet-bbbb0002"
    vpc_id     = "vpc-bbbb2222"
    cidr_block = "10.0.2.0/24"
  }
}

# PASS: subnet_id references a subnet that belongs to the required vpc_id
resource "aws_instance" "pass_subnet_matching_vpc" {
  attrs = {
    ami           = "ami-0123456789abcdef0"
    instance_type = "t3.micro"
    subnet_id     = aws_subnet.matching_vpc.id
  }
}

# FAIL: subnet_id references a subnet that belongs to a different VPC than required
resource "aws_instance" "fail_subnet_mismatched_vpc" {
  expect_failure = true
  attrs = {
    ami           = "ami-0123456789abcdef0"
    instance_type = "t3.micro"
    subnet_id     = aws_subnet.mismatched_vpc.id
  }
}

# PASS: subnet_id does not match any aws_subnet resource in this plan (e.g. an
# existing subnet managed outside this plan). The subnet's VPC membership
# cannot be verified, so the instance is not penalized for this sub-check
# (matches the original Sentinel's check_subnet_vpc fallback of returning true
# when no matching subnet config is found).
resource "aws_instance" "pass_subnet_unresolvable_with_vpc_required" {
  attrs = {
    ami           = "ami-0123456789abcdef0"
    instance_type = "t3.micro"
    subnet_id     = "subnet-does-not-exist-9999"
  }
}
